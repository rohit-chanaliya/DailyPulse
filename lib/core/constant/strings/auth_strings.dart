/// Centralized user-facing strings for the Authentication flow.
abstract final class AuthStrings {
  // Common / Shared
  static const String emailLabel = 'Email Address';
  static const String emailHint = 'Enter your email...';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Enter your password...';
  static const String orDivider = 'OR';
  static const String googleSignInButton = 'Continue with Google';
  static const String privacyPromise =
      'Private & Offline-First • Your data stays with you';

  // Sign In Screen
  static const String signInTitle = 'Welcome Back';
  static const String signInSubtitle =
      'Sign in to continue your mindful journey';
  static const String signInButton = 'Sign In';
  static const String forgotPasswordLink = 'Forgot Password?';
  static const String dontHaveAccount = 'Don\'t have an account? ';
  static const String signUpAction = 'Sign Up';

  // Sign Up Screen
  static const String signUpTitle = 'Create Account';
  static const String signUpSubtitle =
      'Begin your daily emotional wellness journey';
  static const String nameLabel = 'Full Name';
  static const String nameHint = 'Enter your name...';
  static const String signUpButton = 'Create Account';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String signInAction = 'Sign In';
  static const String termsPrefix = 'I agree to the ';
  static const String termsLink = 'Terms & Conditions';
  static const String termsRequiredError =
      'Please accept the Terms & Conditions to proceed';
  static const String accountCreatedSuccess =
      'Account created successfully! Welcome to DailyPulse.';

  // Verify Email Screen
  static const String verifyEmailTitle = 'Verify Your Email';
  static const String verifyEmailSubtitle =
      'We\'ve sent a verification link to your email. Please check your inbox and click the link to verify.';
  static const String resendVerificationButton = 'Resend Verification Email';
  static const String verificationSentSuccess =
      'Verification email sent! Check your inbox.';
  static const String verificationResendSuccess =
      'Verification email resent successfully!';
  static const String alreadyVerifiedButton = 'I\'ve Verified, Continue';
  static const String emailNotVerifiedError =
      'Email not verified yet. Please check your inbox and click the verification link.';
  static const String emailVerifiedSuccess =
      'Email verified successfully! You can now sign in.';
  static const String emailVerificationFailed =
      'Email verification failed. Please request a new link.';
  static const String verificationLinkExpired =
      'This verification link has expired. Please request a new one.';
  static const String verificationLinkInvalid =
      'This verification link is invalid or has already been used.';
  static const String verificationTimeout =
      'Verification is taking too long. Check your connection and try again.';
  static const String signInAfterVerify = 'Go to Sign In';
  static const String checkSpamNote =
      'Didn\'t receive the email? Check your spam folder or resend.';

  // Reset Password Screen
  static const String resetPasswordTitle = 'Set New Password';
  static const String resetPasswordSubtitle =
      'Choose a new password for your account.';
  static const String newPasswordLabel = 'New Password';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String confirmPasswordHint = 'Re-enter your password...';
  static const String resetPasswordButton = 'Reset Password';
  static const String passwordResetSuccess =
      'Password reset successfully! Please sign in with your new password.';
  static const String invalidResetLink =
      'This password reset link is invalid or has expired.';
  static const String passwordMismatchError = 'Passwords do not match';
  static const String emailRecoveryFailed =
      'Could not restore your email address. The link may have expired.';
  static const String emailRecoveredSuccess =
      'Your email address has been restored.';

  // Forgot Password Screen
  static const String forgotPasswordTitle = 'Reset Password';
  static const String forgotPasswordSubtitle =
      'Enter your registered email and we\'ll send you a link to reset your password.';
  static const String sendResetLinkButton = 'Send Reset Link';
  static const String resendResetLinkButton = 'Resend Reset Link';
  static const String resetLinkSentSuccess =
      'Password reset link sent to your email!';
  static const String failedToSendResetLink = 'Failed to send reset link';
  static const String rememberPasswordPrefix = 'Remember your password? ';
  static const String backToSignInAction = 'Sign In';
}
