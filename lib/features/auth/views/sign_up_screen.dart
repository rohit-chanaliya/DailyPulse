import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dailypulse/core/constant/strings/auth_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/snackbar_utils.dart';
import './widgets/auth_back_button.dart';
import './widgets/auth_header.dart';
import './widgets/sign_up_form_card.dart';

/// Minimalist, mindful Sign Up screen with balanced full-screen layout.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedGender;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGender == null) {
      SnackBarUtils.showError(context, AuthStrings.genderRequiredError);
      return;
    }
    if (!_agreeToTerms) {
      SnackBarUtils.showError(context, AuthStrings.termsRequiredError);
      return;
    }

    final email = _emailController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final fullName = '$firstName $lastName'.trim();

    final success = await appComponent.authSignal.signUp(
      email: email,
      password: _passwordController.text,
      name: fullName,
      firstName: firstName,
      lastName: lastName,
      gender: _selectedGender,
    );

    if (!mounted) return;
    if (!success) {
      final message = appComponent.authSignal.errorMessage.value;
      if (message != null) {
        SnackBarUtils.showError(context, message);
      }
      return;
    }

    SnackBarUtils.showSuccess(context, AuthStrings.verificationSentSuccess);
    context.go(AppRoutes.verifyEmail, extra: {'email': email});
  }

  Future<void> _signUpWithGoogle() async {
    final success = await appComponent.authSignal.signInWithGoogle();
    if (!mounted) return;

    if (!success) {
      final message = appComponent.authSignal.errorMessage.value;
      if (message != null) {
        SnackBarUtils.showError(context, message);
      }
      return;
    }

    SnackBarUtils.showSuccess(context, AuthStrings.accountCreatedSuccess);
    context.go(AppRoutes.home);
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
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(AppRoutes.signIn);
                          }
                        },
                      ),
                    ),

                    // Centered Core: Hero Header + Form + Switch Link
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AuthHeader(
                            title: AuthStrings.signUpTitle,
                            subtitle: AuthStrings.signUpSubtitle,
                          ),
                          const SizedBox(height: 28),
                          SignUpFormCard(
                            formKey: _formKey,
                            firstNameController: _firstNameController,
                            lastNameController: _lastNameController,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            selectedGender: _selectedGender,
                            onGenderChanged: (gender) =>
                                setState(() => _selectedGender = gender),
                            agreeToTerms: _agreeToTerms,
                            onTermsChanged: (value) =>
                                setState(() => _agreeToTerms = value),
                            onSubmit: _signUp,
                            onGoogleSignIn: _signUpWithGoogle,
                          ),
                          const SizedBox(height: 28),

                          // Switch to Sign In row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AuthStrings.alreadyHaveAccount,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: onboardingColors.welcomeSubtitle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  if (context.canPop()) {
                                    context.pop();
                                  } else {
                                    context.go(AppRoutes.signIn);
                                  }
                                },
                                child: Text(
                                  AuthStrings.signInAction,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: onboardingColors.welcomeHighlight,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
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
