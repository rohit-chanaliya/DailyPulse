import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inject_annotation/inject_annotation.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/strings/auth_strings.dart';
import 'package:dailypulse/core/utils/app_logger.dart';
import 'package:dailypulse/features/mood/data/repositories/mood_repository.dart';
import 'package:dailypulse/features/mood/data/services/sync_service.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

/// Authentication state backed by signals instead of ChangeNotifier.
@singleton
class AuthSignal {
  @inject
  AuthSignal(this._auth, this._syncService, this._moodRepository) {
    if (!kIsWeb) {
      GoogleSignIn.instance.initialize();
    }
    _authSubscription = _auth.authStateChanges().listen(
      _onAuthStateChanged,
      onError: (Object error, StackTrace stackTrace) {
        errorMessage.value = 'Failed to listen for auth changes';
        appLogger.e('Auth stream error', error: error, stackTrace: stackTrace);
      },
    );
  }

  final FirebaseAuth _auth;
  final SyncService _syncService;
  final MoodRepository _moodRepository;
  late final StreamSubscription<User?> _authSubscription;

  final status = signal<AuthStatus>(AuthStatus.initial);
  final user = signal<User?>(null);
  final errorMessage = signal<String?>(null);

  /// Whether the signed-in user authenticated through Google.
  bool get isGoogleUser {
    final current = user.value;
    if (current == null) return false;
    return current.providerData.any((info) => info.providerId == 'google.com');
  }

  /// Whether the current email/password user has a verified email.
  /// Google sign-in users are always considered verified.
  bool get isEmailVerified =>
      user.value?.emailVerified == true || isGoogleUser;

  bool get isAuthenticated => status.value == AuthStatus.authenticated;

  void _onAuthStateChanged(User? value) {
    if (value == null) {
      user.value = null;
      status.value = AuthStatus.unauthenticated;
      _syncService.stopBackgroundSync();
      return;
    }
    user.value = value;
    status.value = AuthStatus.authenticated;

    // Nothing else starts sync, so this listener is the single entry point:
    // it covers cold starts with a restored session and every sign-in.
    _syncService.startBackgroundSync();
    unawaited(_syncService.syncPendingEntries());

    appLogger.i(
      'Auth state changed: ${status.value.name}, User UID: ${value.uid}',
    );
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      status.value = AuthStatus.loading;
      errorMessage.value = null;

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);

      // Send verification email before signing out.
      await credential.user?.sendEmailVerification();

      // Sign out so the user cannot access the app until verified.
      await _auth.signOut();

      appLogger.i(
        'User signed up, verification email sent: ${credential.user?.uid}',
      );
      return true;
    } on FirebaseAuthException catch (e) {
      status.value = AuthStatus.unauthenticated;
      errorMessage.value = _getErrorMessage(e.code);
      appLogger.w('Sign up failed: ${e.code}');
      return false;
    } catch (e, stackTrace) {
      status.value = AuthStatus.unauthenticated;
      errorMessage.value = 'An unexpected error occurred';
      appLogger.e(
        'Unexpected error during sign up',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      status.value = AuthStatus.loading;
      errorMessage.value = null;

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Block unverified email/password users.
      if (credential.user != null && !credential.user!.emailVerified) {
        await _auth.signOut();
        status.value = AuthStatus.unauthenticated;
        errorMessage.value =
            'Email not verified yet. Please check your inbox and click the verification link.';
        appLogger.w('Sign in blocked – email not verified');
        return false;
      }

      appLogger.i('User signed in successfully: ${user.value?.uid}');
      return true;
    } on FirebaseAuthException catch (e) {
      status.value = AuthStatus.unauthenticated;
      errorMessage.value = _getErrorMessage(e.code);
      appLogger.w('Sign in failed: ${e.code}');
      return false;
    } catch (e, stackTrace) {
      status.value = AuthStatus.unauthenticated;
      errorMessage.value = 'An unexpected error occurred';
      appLogger.e(
        'Unexpected error during sign in',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<void> signOut() async {
    appLogger.i('User signed out: ${user.value?.uid}');
    try {
      if (!kIsWeb) {
        await GoogleSignIn.instance.signOut();
      }
    } catch (e) {
      appLogger.w('Google sign out non-fatal error: $e');
    }
    await _auth.signOut();
  }

  Future<bool> signInWithGoogle() async {
    try {
      status.value = AuthStatus.loading;
      errorMessage.value = null;

      final UserCredential userCredential;
      if (kIsWeb) {
        final GoogleAuthProvider authProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(authProvider);
      } else {
        userCredential = await _auth.signInWithCredential(
          await _googleCredential(),
        );
      }

      user.value = userCredential.user;
      status.value = AuthStatus.authenticated;
      appLogger.i('User signed in with Google: ${user.value?.uid}');
      return true;
    } on FirebaseAuthException catch (e) {
      status.value = AuthStatus.unauthenticated;
      errorMessage.value = _getErrorMessage(e.code);
      appLogger.w('Google Sign In failed: ${e.code}');
      return false;
    } catch (e, stackTrace) {
      status.value = AuthStatus.unauthenticated;
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('canceled') || errStr.contains('cancelled')) {
        appLogger.i('Google Sign In cancelled by user');
        errorMessage.value = null;
      } else {
        errorMessage.value = 'Failed to sign in with Google';
        appLogger.e(
          'Unexpected Google sign in error',
          error: e,
          stackTrace: stackTrace,
        );
      }
      return false;
    }
  }

  Future<void> handleGoogleSignIn({
    Function()? onSuccess,
    Function(String)? onError,
  }) async {
    final success = await signInWithGoogle();
    if (success) {
      onSuccess?.call();
    } else if (errorMessage.value != null) {
      onError?.call(errorMessage.value!);
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    try {
      status.value = AuthStatus.loading;
      errorMessage.value = null;
      await _auth.sendPasswordResetEmail(email: email);
      status.value = AuthStatus.unauthenticated;
      appLogger.i('Password reset email sent successfully');
      return true;
    } on FirebaseAuthException catch (e) {
      status.value = AuthStatus.unauthenticated;
      errorMessage.value = _getErrorMessage(e.code);
      appLogger.w('Password reset failed: ${e.code}');
      return false;
    } catch (e, stackTrace) {
      status.value = AuthStatus.unauthenticated;
      errorMessage.value = 'Failed to send reset link';
      appLogger.e('Unexpected password reset error', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  void clearError() {
    errorMessage.value = null;
  }

  /// Resend the email verification link.
  ///
  /// Temporarily signs in the user, sends the email, then signs out again.
  Future<bool> resendVerificationEmail({
    required String email,
    required String password,
  }) async {
    try {
      errorMessage.value = null;

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null && credential.user!.emailVerified) {
        // Already verified — stay signed in.
        appLogger.i('User already verified, staying signed in');
        return true;
      }

      await credential.user?.sendEmailVerification();
      await _auth.signOut();
      appLogger.i('Verification email resent');
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getErrorMessage(e.code);
      appLogger.w('Resend verification failed: ${e.code}');
      return false;
    } catch (e, stackTrace) {
      errorMessage.value = 'Failed to resend verification email';
      appLogger.e(
        'Unexpected error resending verification email',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Apply an email verification action code received via deep link.
  Future<bool> applyVerificationCode(String oobCode) async {
    try {
      await _auth
          .applyActionCode(oobCode)
          .timeout(const Duration(seconds: 15));
      appLogger.i('Email verification code applied successfully');
      return true;
    } on TimeoutException {
      errorMessage.value = AuthStrings.verificationTimeout;
      appLogger.w('Apply verification code timed out');
      return false;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getErrorMessage(e.code);
      appLogger.w('Apply verification code failed: ${e.code}');
      return false;
    } catch (e, stackTrace) {
      errorMessage.value = 'Failed to verify email';
      appLogger.e(
        'Unexpected error applying verification code',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Restore a previous email address from a `recoverEmail` action link.
  Future<bool> applyRecoveryCode(String oobCode) async {
    try {
      await _auth
          .applyActionCode(oobCode)
          .timeout(const Duration(seconds: 15));
      appLogger.i('Email recovery code applied successfully');
      return true;
    } on TimeoutException {
      errorMessage.value = AuthStrings.verificationTimeout;
      appLogger.w('Email recovery code timed out');
      return false;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getErrorMessage(e.code);
      appLogger.w('Apply recovery code failed: ${e.code}');
      return false;
    } catch (e, stackTrace) {
      errorMessage.value = AuthStrings.emailRecoveryFailed;
      appLogger.e(
        'Unexpected error applying recovery code',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Validate a password reset code and return the account email.
  Future<String?> verifyPasswordResetCode(String oobCode) async {
    try {
      return await _auth
          .verifyPasswordResetCode(oobCode)
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      errorMessage.value = AuthStrings.verificationTimeout;
      appLogger.w('Verify password reset code timed out');
      return null;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getResetErrorMessage(e.code);
      appLogger.w('Verify password reset code failed: ${e.code}');
      return null;
    } catch (e, stackTrace) {
      errorMessage.value = AuthStrings.invalidResetLink;
      appLogger.e(
        'Unexpected error verifying reset code',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Complete a password reset with a new password.
  Future<bool> confirmPasswordReset({
    required String oobCode,
    required String newPassword,
  }) async {
    try {
      await _auth
          .confirmPasswordReset(code: oobCode, newPassword: newPassword)
          .timeout(const Duration(seconds: 15));
      appLogger.i('Password reset completed successfully');
      return true;
    } on TimeoutException {
      errorMessage.value = AuthStrings.verificationTimeout;
      appLogger.w('Confirm password reset timed out');
      return false;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getResetErrorMessage(e.code);
      appLogger.w('Confirm password reset failed: ${e.code}');
      return false;
    } catch (e, stackTrace) {
      errorMessage.value = AuthStrings.invalidResetLink;
      appLogger.e(
        'Unexpected error confirming password reset',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<void> handleSignIn({
    required String email,
    required String password,
    required Function(String) onError,
  }) async {
    final success = await signIn(email: email, password: password);
    final message = errorMessage.value;
    if (!success && message != null) {
      onError(message);
    }
  }

  Future<void> handleSignUp({
    required String email,
    required String password,
    required String name,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    final success = await signUp(email: email, password: password, name: name);
    if (success) {
      onSuccess();
    } else if (errorMessage.value != null) {
      onError(errorMessage.value!);
    }
  }

  String _getResetErrorMessage(String code) {
    switch (code) {
      case 'expired-action-code':
      case 'invalid-action-code':
        return AuthStrings.invalidResetLink;
      default:
        return _getErrorMessage(code);
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password is too weak';
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'expired-action-code':
        return AuthStrings.verificationLinkExpired;
      case 'invalid-action-code':
        return AuthStrings.verificationLinkInvalid;
      case 'user-disabled':
        return 'This account has been disabled';
      default:
        return 'Authentication failed. Please try again';
    }
  }

  /// Permanently deletes the signed-in account and every data trace of it.
  ///
  /// [password] is only needed for email/password accounts whose session is
  /// older than Firebase's recent-login window; Google accounts re-authenticate
  /// through the account picker.
  ///
  /// Order matters: the remote/local wipe runs while the user is still signed
  /// in, because the security rules only allow owners to delete their own
  /// documents. Deleting the Auth user first would make that wipe impossible.
  Future<bool> deleteAccount({String? password}) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      errorMessage.value = AuthStrings.deleteAccountNoUser;
      return false;
    }

    try {
      if (!await _hasRecentLogin(currentUser)) {
        await _reauthenticate(currentUser, password);
      }

      final dataDeleted = await _moodRepository.deleteAccountData(
        currentUser.uid,
      );
      if (!dataDeleted) {
        errorMessage.value = AuthStrings.deleteAccountDataFailed;
        return false;
      }

      try {
        await currentUser.delete();
      } on FirebaseAuthException catch (e) {
        if (e.code != 'requires-recent-login') rethrow;
        await _reauthenticate(currentUser, password);
        await currentUser.delete();
      }

      appLogger.i('Account deleted: ${currentUser.uid}');
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getErrorMessage(e.code);
      appLogger.w('Account deletion failed: ${e.code}');
      return false;
    } on GoogleSignInException catch (e) {
      errorMessage.value = e.code == GoogleSignInExceptionCode.canceled
          ? AuthStrings.deleteAccountCancelled
          : AuthStrings.deleteAccountFailed;
      appLogger.w('Account deletion re-auth failed: ${e.code}');
      return false;
    } catch (e, stackTrace) {
      errorMessage.value = AuthStrings.deleteAccountFailed;
      appLogger.e(
        'Unexpected error deleting account',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Firebase only asks for a fresh login within a few minutes of sign-in.
  Future<bool> _hasRecentLogin(User user) async {
    final lastSignIn = user.metadata.lastSignInTime;
    if (lastSignIn == null) return false;
    return DateTime.now().difference(lastSignIn) <
        const Duration(minutes: 4);
  }

  Future<void> _reauthenticate(User user, String? password) async {
    final credential = isGoogleUser
        ? await _googleCredential()
        : EmailAuthProvider.credential(
            email: user.email ?? '',
            password: password ?? '',
          );
    await user.reauthenticateWithCredential(credential);
  }

  Future<AuthCredential> _googleCredential() async {
    final googleUser = await GoogleSignIn.instance.authenticate();
    final googleAuth = googleUser.authentication;
    return GoogleAuthProvider.credential(idToken: googleAuth.idToken);
  }

  void dispose() {
    _authSubscription.cancel();
  }
}
