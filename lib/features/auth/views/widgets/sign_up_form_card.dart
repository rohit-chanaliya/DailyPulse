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

/// The sign-up form: name/email/password, terms and both submit actions.
class SignUpFormCard extends StatelessWidget {
  const SignUpFormCard({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.agreeToTerms,
    required this.onTermsChanged,
    required this.onSubmit,
    required this.onGoogleSignIn,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final bool agreeToTerms;
  final ValueChanged<bool> onTermsChanged;
  final VoidCallback onSubmit;
  final VoidCallback onGoogleSignIn;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: nameController,
            label: AuthStrings.nameLabel,
            hintText: AuthStrings.nameHint,
            keyboardType: TextInputType.name,
            validator: Validators.validateName,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: emailController,
            label: AuthStrings.emailLabel,
            hintText: AuthStrings.emailHint,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: passwordController,
            label: AuthStrings.passwordLabel,
            hintText: AuthStrings.passwordHint,
            isPassword: true,
            validator: Validators.validatePasswordStrength,
          ),
          const SizedBox(height: 14),
          AuthTermsCheckbox(
            isChecked: agreeToTerms,
            onChanged: onTermsChanged,
          ),
          const SizedBox(height: 22),
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
