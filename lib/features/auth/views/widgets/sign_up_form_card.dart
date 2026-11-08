import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/strings/auth_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/validators.dart';
import 'package:dailypulse/core/widgets/custom_text_field.dart';
import 'package:dailypulse/features/auth/viewmodels/auth_signal.dart';
import 'auth_google_button.dart';
import 'auth_primary_button.dart';
import 'auth_terms_checkbox.dart';

/// The sign-up form: first name, last name, gender, email, password, terms and actions.
class SignUpFormCard extends StatelessWidget {
  const SignUpFormCard({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.agreeToTerms,
    required this.onTermsChanged,
    required this.onSubmit,
    required this.onGoogleSignIn,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? selectedGender;
  final ValueChanged<String> onGenderChanged;
  final bool agreeToTerms;
  final ValueChanged<bool> onTermsChanged;
  final VoidCallback onSubmit;
  final VoidCallback onGoogleSignIn;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final buttons = context.buttons;
    final onboarding = context.onboarding;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Name & Last Name in one row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextField(
                  controller: firstNameController,
                  label: AuthStrings.firstNameLabel,
                  hintText: AuthStrings.firstNameHint,
                  keyboardType: TextInputType.name,
                  validator: Validators.validateFirstName,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  controller: lastNameController,
                  label: AuthStrings.lastNameLabel,
                  hintText: AuthStrings.lastNameHint,
                  keyboardType: TextInputType.name,
                  validator: Validators.validateLastName,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Gender Selection
          Text(
            AuthStrings.genderLabel,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: home.textSecondary,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final gender in const ['Male', 'Female', 'Other']) ...[
                Expanded(
                  child: InkWell(
                    onTap: () => onGenderChanged(gender),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedGender == gender
                            ? onboarding.welcomeHighlight
                                .withValues(alpha: 0.15)
                            : buttons.surfaceBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selectedGender == gender
                              ? onboarding.welcomeHighlight
                              : buttons.surfaceBorder,
                          width: selectedGender == gender ? 1.8 : 1.2,
                        ),
                      ),
                      child: Text(
                        gender,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: selectedGender == gender
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: selectedGender == gender
                              ? onboarding.welcomeHighlight
                              : home.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                if (gender != 'Other') const SizedBox(width: 10),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // Email Field
          CustomTextField(
            controller: emailController,
            label: AuthStrings.emailLabel,
            hintText: AuthStrings.emailHint,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 16),

          // Password Field
          CustomTextField(
            controller: passwordController,
            label: AuthStrings.passwordLabel,
            hintText: AuthStrings.passwordHint,
            isPassword: true,
            validator: Validators.validatePasswordStrength,
          ),
          const SizedBox(height: 14),

          // Terms Checkbox
          AuthTermsCheckbox(
            isChecked: agreeToTerms,
            onChanged: onTermsChanged,
          ),
          const SizedBox(height: 22),

          // Submit CTA
          SignalBuilder(
            builder: (context) {
              final isLoading =
                  appComponent.authSignal.status.value == AuthStatus.loading;
              return AuthPrimaryButton(
                text: AuthStrings.signUpButton,
                isLoading: isLoading,
                onPressed: onSubmit,
              );
            },
          ),
          const SizedBox(height: 20),
          const _OrDivider(),
          const SizedBox(height: 20),

          // Google Button
          SignalBuilder(
            builder: (context) {
              final isLoading =
                  appComponent.authSignal.status.value == AuthStatus.loading;
              return AuthGoogleButton(
                isLoading: isLoading,
                onPressed: onGoogleSignIn,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final color = context.onboarding.welcomeSubtitle.withValues(alpha: 0.2);

    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            AuthStrings.orDivider,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.onboarding.welcomeSubtitle,
            ),
          ),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }
}
