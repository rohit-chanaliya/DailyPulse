import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/auth_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/validators.dart';
import 'package:dailypulse/core/widgets/custom_text_field.dart';
import 'auth_card.dart';
import 'auth_primary_button.dart';

/// Form for choosing a new password after opening a reset link.
class ResetPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool obscurePassword;
  final bool isSubmitting;
  final String? email;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;

  const ResetPasswordForm({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.confirmController,
    required this.obscurePassword,
    required this.isSubmitting,
    required this.onToggleObscure,
    required this.onSubmit,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    final onboardingColors = context.onboarding;

    return AuthCard(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            if (email != null && email!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: onboardingColors.welcomeHighlight.withValues(
                    alpha: 0.08,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: onboardingColors.welcomeHighlight.withValues(
                      alpha: 0.2,
                    ),
                  ),
                ),
                child: Text(
                  email!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: onboardingColors.welcomeHighlight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            CustomTextField(
              controller: passwordController,
              label: AuthStrings.newPasswordLabel,
              hintText: AuthStrings.passwordHint,
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: onboardingColors.welcomeSubtitle,
                ),
                onPressed: onToggleObscure,
              ),
              validator: Validators.validatePasswordStrength,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: confirmController,
              label: AuthStrings.confirmPasswordLabel,
              hintText: AuthStrings.confirmPasswordHint,
              prefixIcon: Icons.lock_reset_rounded,
              obscureText: obscurePassword,
              validator: (value) {
                if (value != passwordController.text) {
                  return AuthStrings.passwordMismatchError;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            AuthPrimaryButton(
              text: AuthStrings.resetPasswordButton,
              isLoading: isSubmitting,
              onPressed: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
