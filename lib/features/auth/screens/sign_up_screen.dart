import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:dailypulse/core/constant/strings/auth_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/snackbar_utils.dart';
import 'package:dailypulse/core/utils/validators.dart';
import 'package:dailypulse/core/widgets/custom_text_field.dart';
import 'package:dailypulse/features/auth/presentation/signals/auth_signal.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_google_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_terms_checkbox.dart';
import '../widgets/auth_trust_badge.dart';

/// Minimalist, mindful Sign Up screen with balanced full-screen layout.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_agreeToTerms) {
      SnackBarUtils.showError(
        context,
        AuthStrings.termsRequiredError,
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      await appComponent.authSignal.handleSignUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        onSuccess: () {
          if (mounted) {
            SnackBarUtils.showSuccess(
              context,
              AuthStrings.verificationSentSuccess,
            );
            context.go(
              AppRoutes.verifyEmail,
              extra: {
                'email': _emailController.text.trim(),
                'password': _passwordController.text,
              },
            );
          }
        },
        onError: (message) {
          if (mounted) {
            SnackBarUtils.showError(context, message);
          }
        },
      );
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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

                    // Centered Core: Hero Header + Form Card + Switch Link
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AuthHeader(
                            title: AuthStrings.signUpTitle,
                            subtitle: AuthStrings.signUpSubtitle,
                          ),
                          const SizedBox(height: 24),

                          // Form Card grouping inputs, terms, and primary action
                          AuthCard(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomTextField(
                                    controller: _nameController,
                                    label: AuthStrings.nameLabel,
                                    hintText: AuthStrings.nameHint,
                                    prefixIcon: Icons.person_outline_rounded,
                                    keyboardType: TextInputType.name,
                                    validator: Validators.validateName,
                                  ),
                                  const SizedBox(height: 16),

                                  CustomTextField(
                                    controller: _emailController,
                                    label: AuthStrings.emailLabel,
                                    hintText: AuthStrings.emailHint,
                                    prefixIcon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: Validators.validateEmail,
                                  ),
                                  const SizedBox(height: 16),

                                  CustomTextField(
                                    controller: _passwordController,
                                    label: AuthStrings.passwordLabel,
                                    hintText: AuthStrings.passwordHint,
                                    prefixIcon: Icons.lock_outline_rounded,
                                    obscureText: _obscurePassword,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        size: 20,
                                        color: onboardingColors.welcomeSubtitle,
                                      ),
                                      onPressed: () => setState(
                                        () => _obscurePassword = !_obscurePassword,
                                      ),
                                    ),
                                    validator: Validators.validatePasswordStrength,
                                  ),
                                  const SizedBox(height: 14),

                                  // Terms & Conditions Checkbox
                                  AuthTermsCheckbox(
                                    isChecked: _agreeToTerms,
                                    onChanged: (val) =>
                                        setState(() => _agreeToTerms = val),
                                  ),
                                  const SizedBox(height: 22),

                                  // Primary Sign Up Button
                                  SignalBuilder(
                                    builder: (context) {
                                      final isLoading =
                                          appComponent.authSignal.status.value ==
                                              AuthStatus.loading;

                                      return AuthPrimaryButton(
                                        text: AuthStrings.signUpButton,
                                        isLoading: isLoading,
                                        onPressed: _signUp,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Mindful OR Divider
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: onboardingColors.welcomeSubtitle
                                              .withValues(alpha: 0.25),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                        ),
                                        child: Text(
                                          AuthStrings.orDivider,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                onboardingColors.welcomeSubtitle,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: onboardingColors.welcomeSubtitle
                                              .withValues(alpha: 0.25),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Google Sign-In Button
                                  SignalBuilder(
                                    builder: (context) {
                                      final isLoading =
                                          appComponent.authSignal.status.value ==
                                              AuthStatus.loading;

                                      return AuthGoogleButton(
                                        isLoading: isLoading,
                                        onPressed: () async {
                                          await appComponent.authSignal
                                              .handleGoogleSignIn(
                                            onSuccess: () {
                                              if (mounted) {
                                                SnackBarUtils.showSuccess(
                                                  context,
                                                  AuthStrings.accountCreatedSuccess,
                                                );
                                                context.go(AppRoutes.home);
                                              }
                                            },
                                            onError: (message) {
                                              if (mounted) {
                                                SnackBarUtils.showError(
                                                  context,
                                                  message,
                                                );
                                              }
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

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

                    // Bottom Mindful Trust Badge
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
