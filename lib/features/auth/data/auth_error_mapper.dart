import 'package:inject_annotation/inject_annotation.dart';

import 'package:dailypulse/core/constant/strings/auth_strings.dart';

/// Maps Firebase Auth error codes to user-facing copy.
@singleton
class AuthErrorMapper {
  @inject
  AuthErrorMapper();

  String messageFor(String code) => switch (code) {
    'weak-password' => AuthStrings.weakPassword,
    'email-already-in-use' => AuthStrings.emailAlreadyInUse,
    'invalid-email' => AuthStrings.invalidEmail,
    'user-not-found' => AuthStrings.userNotFound,
    'wrong-password' => AuthStrings.wrongPassword,
    'invalid-credential' => AuthStrings.invalidCredential,
    'expired-action-code' => AuthStrings.verificationLinkExpired,
    'invalid-action-code' => AuthStrings.verificationLinkInvalid,
    'user-disabled' => AuthStrings.userDisabled,
    _ => AuthStrings.authFailedFallback,
  };

  /// Reset-password links share two codes with email verification but need
  /// different copy.
  String resetMessageFor(String code) => switch (code) {
    'expired-action-code' || 'invalid-action-code' => AuthStrings
        .invalidResetLink,
    _ => messageFor(code),
  };
}
