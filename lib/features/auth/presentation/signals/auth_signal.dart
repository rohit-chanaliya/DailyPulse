import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inject_annotation/inject_annotation.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/strings/auth_strings.dart';
import 'package:dailypulse/core/utils/app_logger.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

/// Authentication state backed by signals instead of ChangeNotifier.
@singleton
class AuthSignal {
  @inject
  AuthSignal(this._auth) {
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
  late final StreamSubscription<User?> _authSubscription;

  final status = signal<AuthStatus>(AuthStatus.initial);
  final user = signal<User?>(null);
  final errorMessage = signal<String?>(null);

  /// Whether the current email/password user has a verified email.
  /// Google sign-in users are always considered verified.
  bool get isEmailVerified =>
      user.value?.emailVerified == true ||
      _isGoogleUser(user.value);

  bool _isGoogleUser(User? u) {
    if (u == null) return false;
    return u.providerData.any((info) => info.providerId == 'google.com');
  }

  bool get isAuthenticated => status.value == AuthStatus.authenticated;

  void _onAuthStateChanged(User? value) {
    if (value == null) {
      user.value = null;
      status.value = AuthStatus.unauthenticated;
      return;
    }
    user.value = value;
    status.value = AuthStatus.authenticated;
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
        final GoogleSignInAccount googleUser =
            await GoogleSignIn.instance.authenticate();
        final GoogleSignInAuthentication googleAuth = googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        userCredential = await _auth.signInWithCredential(credential);
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

  void dispose() {
    _authSubscription.cancel();
  }
}
