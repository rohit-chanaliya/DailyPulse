import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inject_annotation/inject_annotation.dart';

import 'package:dailypulse/core/constant/strings/auth_strings.dart';
import 'package:dailypulse/core/utils/app_logger.dart';
import 'package:dailypulse/core/utils/result.dart';
import 'auth_error_mapper.dart';

/// All Firebase Auth and Google Sign-In access for the auth feature.
///
/// Returns [Result] values instead of throwing, so the signal layer only has
/// to map outcomes to state.
@singleton
class AuthRepository {
  @inject
  AuthRepository(this._auth, this._errorMapper) {
    if (!kIsWeb) {
      unawaited(GoogleSignIn.instance.initialize());
    }
  }

  final FirebaseAuth _auth;
  final AuthErrorMapper _errorMapper;

  static const Duration _actionTimeout = Duration(seconds: 15);

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<Result<void>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);

      // The account exists at this point; a failed verification email must not
      // fail the sign-up. The user can resend it from the verify screen.
      try {
        await credential.user?.sendEmailVerification();
      } catch (e, stackTrace) {
        appLogger.e(
          'Verification email could not be sent during sign up',
          error: e,
          stackTrace: stackTrace,
        );
      }

      appLogger.i('User signed up');
      return const Ok(null);
    } on FirebaseAuthException catch (e) {
      appLogger.w('Sign up failed: ${e.code}');
      return Err(_errorMapper.messageFor(e.code));
    } catch (e, stackTrace) {
      appLogger.e(
        'Unexpected error during sign up',
        error: e,
        stackTrace: stackTrace,
      );
      return const Err(AuthStrings.unexpectedError);
    }
  }

  Future<Result<void>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null && !user.emailVerified) {
        await _auth.signOut();
        appLogger.w('Sign in blocked – email not verified');
        return const Err(AuthStrings.emailNotVerifiedError);
      }
      return const Ok(null);
    } on FirebaseAuthException catch (e) {
      appLogger.w('Sign in failed: ${e.code}');
      return Err(_errorMapper.messageFor(e.code));
    } catch (e, stackTrace) {
      appLogger.e(
        'Unexpected error during sign in',
        error: e,
        stackTrace: stackTrace,
      );
      return const Err(AuthStrings.unexpectedError);
    }
  }

  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await GoogleSignIn.instance.signOut();
      }
    } catch (e) {
      appLogger.w('Google sign out non-fatal error: $e');
    }
    await _auth.signOut();
  }

  Future<Result<void>> signInWithGoogle() async {
    try {
      final credential = kIsWeb
          ? await _auth.signInWithPopup(GoogleAuthProvider())
          : await _auth.signInWithCredential(await _googleCredential());

      if (credential.user == null) {
        return const Err(AuthStrings.googleSignInFailed);
      }
      return const Ok(null);
    } on FirebaseAuthException catch (e) {
      appLogger.w('Google Sign In failed: ${e.code}');
      return Err(_errorMapper.messageFor(e.code));
    } catch (e, stackTrace) {
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('canceled') || errStr.contains('cancelled')) {
        appLogger.i('Google Sign In cancelled by user');
        return const Err();
      }
      appLogger.e(
        'Unexpected Google sign in error',
        error: e,
        stackTrace: stackTrace,
      );
      return const Err(AuthStrings.googleSignInFailed);
    }
  }

  Future<Result<void>> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Ok(null);
    } on FirebaseAuthException catch (e) {
      appLogger.w('Password reset failed: ${e.code}');
      return Err(_errorMapper.messageFor(e.code));
    } catch (e, stackTrace) {
      appLogger.e(
        'Unexpected password reset error',
        error: e,
        stackTrace: stackTrace,
      );
      return const Err(AuthStrings.failedToSendResetLink);
    }
  }

  /// Resends the verification email to the currently signed-in user.
  Future<Result<void>> resendVerificationEmail() async {
    final current = _auth.currentUser;
    if (current == null) {
      return const Err(AuthStrings.noSignedInUser);
    }
    if (current.emailVerified) {
      return const Ok(null);
    }
    try {
      await current.sendEmailVerification();
      return const Ok(null);
    } on FirebaseAuthException catch (e) {
      appLogger.w('Resend verification failed: ${e.code}');
      return Err(_errorMapper.messageFor(e.code));
    } catch (e, stackTrace) {
      appLogger.e(
        'Unexpected error resending verification email',
        error: e,
        stackTrace: stackTrace,
      );
      return const Err(AuthStrings.failedToResendVerification);
    }
  }

  Future<Result<void>> applyVerificationCode(String oobCode) async {
    return _applyActionCode(oobCode, failureMessage: AuthStrings.failedToVerifyEmail);
  }

  Future<Result<void>> applyRecoveryCode(String oobCode) async {
    return _applyActionCode(
      oobCode,
      failureMessage: AuthStrings.failedToRestoreEmail,
    );
  }

  /// Applies an email action link and refreshes the signed-in user, if any.
  Future<Result<void>> _applyActionCode(
    String oobCode, {
    required String failureMessage,
  }) async {
    try {
      await _auth.applyActionCode(oobCode).timeout(_actionTimeout);
      await _auth.currentUser?.reload();
      return const Ok(null);
    } on TimeoutException {
      appLogger.w('Apply action code timed out');
      return const Err(AuthStrings.verificationTimeout);
    } on FirebaseAuthException catch (e) {
      appLogger.w('Apply action code failed: ${e.code}');
      return Err(_errorMapper.messageFor(e.code));
    } catch (e, stackTrace) {
      appLogger.e(
        'Unexpected error applying action code',
        error: e,
        stackTrace: stackTrace,
      );
      return Err(failureMessage);
    }
  }

  /// Validates a password reset code and returns the account email.
  Future<Result<String>> verifyPasswordResetCode(String oobCode) async {
    try {
      final email = await _auth
          .verifyPasswordResetCode(oobCode)
          .timeout(_actionTimeout);
      return Ok(email);
    } on TimeoutException {
      appLogger.w('Verify password reset code timed out');
      return const Err(AuthStrings.verificationTimeout);
    } on FirebaseAuthException catch (e) {
      appLogger.w('Verify password reset code failed: ${e.code}');
      return Err(_errorMapper.resetMessageFor(e.code));
    } catch (e, stackTrace) {
      appLogger.e(
        'Unexpected error verifying reset code',
        error: e,
        stackTrace: stackTrace,
      );
      return const Err(AuthStrings.invalidResetLink);
    }
  }

  Future<Result<void>> confirmPasswordReset({
    required String oobCode,
    required String newPassword,
  }) async {
    try {
      await _auth
          .confirmPasswordReset(code: oobCode, newPassword: newPassword)
          .timeout(_actionTimeout);
      return const Ok(null);
    } on TimeoutException {
      appLogger.w('Confirm password reset timed out');
      return const Err(AuthStrings.verificationTimeout);
    } on FirebaseAuthException catch (e) {
      appLogger.w('Confirm password reset failed: ${e.code}');
      return Err(_errorMapper.resetMessageFor(e.code));
    } catch (e, stackTrace) {
      appLogger.e(
        'Unexpected error confirming password reset',
        error: e,
        stackTrace: stackTrace,
      );
      return const Err(AuthStrings.invalidResetLink);
    }
  }

  /// Reloads the signed-in user and reports whether the email is verified.
  Future<Result<bool>> checkEmailVerified() async {
    final current = _auth.currentUser;
    if (current == null) {
      return const Err(AuthStrings.noSignedInUser);
    }
    try {
      await current.reload();
      return Ok(_auth.currentUser?.emailVerified ?? false);
    } on FirebaseAuthException catch (e) {
      appLogger.w('Refresh verification failed: ${e.code}');
      return Err(_errorMapper.messageFor(e.code));
    } catch (e, stackTrace) {
      appLogger.e(
        'Unexpected error refreshing verification',
        error: e,
        stackTrace: stackTrace,
      );
      return const Err(AuthStrings.failedToVerifyEmail);
    }
  }

  /// Permanently deletes the signed-in Auth user.
  ///
  /// Callers must wipe user data first: the Firestore rules only allow owners
  /// to delete their own documents.
  Future<Result<void>> deleteAccount({String? password}) async {
    final current = _auth.currentUser;
    if (current == null) {
      return const Err(AuthStrings.deleteAccountNoUser);
    }

    try {
      if (!_hasRecentLogin(current)) {
        await _reauthenticate(current, password);
      }

      try {
        await current.delete();
      } on FirebaseAuthException catch (e) {
        if (e.code != 'requires-recent-login') rethrow;
        await _reauthenticate(current, password);
        await current.delete();
      }

      appLogger.i('Account deleted: ${current.uid}');
      return const Ok(null);
    } on FirebaseAuthException catch (e) {
      appLogger.w('Account deletion failed: ${e.code}');
      return Err(_errorMapper.messageFor(e.code));
    } on GoogleSignInException catch (e) {
      appLogger.w('Account deletion re-auth failed: ${e.code}');
      return Err(
        e.code == GoogleSignInExceptionCode.canceled
            ? AuthStrings.deleteAccountCancelled
            : AuthStrings.deleteAccountFailed,
      );
    } catch (e, stackTrace) {
      appLogger.e(
        'Unexpected error deleting account',
        error: e,
        stackTrace: stackTrace,
      );
      return const Err(AuthStrings.deleteAccountFailed);
    }
  }

  /// Firebase only asks for a fresh login within a few minutes of sign-in.
  bool _hasRecentLogin(User user) {
    final lastSignIn = user.metadata.lastSignInTime;
    if (lastSignIn == null) return false;
    return DateTime.now().difference(lastSignIn) <
        const Duration(minutes: 4);
  }

  Future<void> _reauthenticate(User user, String? password) async {
    final isGoogleUser = user.providerData.any(
      (info) => info.providerId == 'google.com',
    );
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
}
