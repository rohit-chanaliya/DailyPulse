import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dailypulse/core/constant/strings/auth_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/snackbar_utils.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_trust_badge.dart';

/// Screen shown after sign-up while the user verifies their email.
class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final String password;

  const VerifyEmailScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isResending = false;
  bool _isChecking = false;

  Future<void> _resendEmail() async {
    setState(() => _isResending = true);
    final success = await appComponent.authSignal.resendVerificationEmail(
      email: widget.email,
      password: widget.password,
    );
    if (mounted) {
      setState(() => _isResending = false);
      if (success) {
        SnackBarUtils.showSuccess(context, AuthStrings.verificationResendSuccess);
      } else {
        SnackBarUtils.showError(
          context,
          appComponent.authSignal.errorMessage.value ??
              'Failed to resend email',
        );
      }
    }
  }

  Future<void> _checkVerification() async {
    setState(() => _isChecking = true);

    // Try signing in to check if the email has been verified.
    final success = await appComponent.authSignal.signIn(
      email: widget.email,
      password: widget.password,
    );

    if (mounted) {
      setState(() => _isChecking = false);
      if (success) {
        SnackBarUtils.showSuccess(context, AuthStrings.emailVerifiedSuccess);
        context.go(AppRoutes.home);
      } else {
        SnackBarUtils.showError(
          context,
          AuthStrings.emailNotVerifiedError,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardingColors = context.onboarding;

    return Scaffold(
      backgroundColor: onboardingColors.welcomeBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Navigation
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AuthBackButton(
                        onPressed: () => context.go(AppRoutes.signIn),
                      ),
                    ),

                    // Centered content
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AuthHeader(
                            title: AuthStrings.verifyEmailTitle,
                            subtitle: AuthStrings.verifyEmailSubtitle,
                          ),
                          const SizedBox(height: 8),

                          // Email display chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: onboardingColors.welcomeHighlight
                                  .withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: onboardingColors.welcomeHighlight
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: 16,
                                  color: onboardingColors.welcomeHighlight,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    widget.email,
                                    style:
                                        context.textTheme.bodyMedium?.copyWith(
                                      color: onboardingColors.welcomeHighlight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Action Card
                          AuthCard(
                            child: Column(
                              children: [
                                // Mail illustration
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: onboardingColors.welcomeHighlight
                                        .withValues(alpha: 0.1),
                                  ),
                                  child: Icon(
                                    Icons.mark_email_unread_outlined,
                                    size: 40,
                                    color: onboardingColors.welcomeHighlight,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Spam note
                                Text(
                                  AuthStrings.checkSpamNote,
                                  textAlign: TextAlign.center,
                                  style:
                                      context.textTheme.bodySmall?.copyWith(
                                    color: onboardingColors.welcomeSubtitle,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Primary: I've Verified, Continue
                                AuthPrimaryButton(
                                  text: AuthStrings.alreadyVerifiedButton,
                                  isLoading: _isChecking,
                                  onPressed: _checkVerification,
                                ),
                                const SizedBox(height: 12),

                                // Secondary: Resend
                                OutlinedButton.icon(
                                  onPressed:
                                      _isResending ? null : _resendEmail,
                                  icon: _isResending
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.refresh_rounded,
                                          size: 18),
                                  label: Text(
                                    AuthStrings.resendVerificationButton,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    foregroundColor:
                                        onboardingColors.welcomeHighlight,
                                    side: BorderSide(
                                      color: onboardingColors.welcomeHighlight
                                          .withValues(alpha: 0.4),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Go to sign in
                          GestureDetector(
                            onTap: () => context.go(AppRoutes.signIn),
                            child: Text(
                              AuthStrings.signInAfterVerify,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: onboardingColors.welcomeHighlight,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom Trust Badge
                    const AuthTrustBadge(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
