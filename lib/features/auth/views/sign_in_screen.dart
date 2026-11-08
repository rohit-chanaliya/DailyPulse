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
import 'package:dailypulse/features/auth/viewmodels/auth_signal.dart';
import './widgets/auth_google_button.dart';
import './widgets/auth_header.dart';
import './widgets/auth_primary_button.dart';

/// Minimalist, mindful Sign In screen with balanced full-screen layout.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await appComponent.authSignal.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted || success) return;

    final message = appComponent.authSignal.errorMessage.value;
    if (message == AuthStrings.emailNotVerifiedError) {
      SnackBarUtils.showError(context, message!);
      context.go(
        AppRoutes.verifyEmail,
        extra: {'email': _emailController.text.trim()},
      );
      return;
    }
    if (message != null) {
      SnackBarUtils.showError(context, message);
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AuthHeader(
                      title: AuthStrings.signInTitle,
                      subtitle: AuthStrings.signInSubtitle,
                    ),
                    const SizedBox(height: 28),

                    Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: _emailController,
                                  label: AuthStrings.emailLabel,
                                  hintText: AuthStrings.emailHint,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: Validators.validateEmail,
                                ),
                                const SizedBox(height: 18),
                                CustomTextField(
                                  controller: _passwordController,
                                  label: AuthStrings.passwordLabel,
                                  hintText: AuthStrings.passwordHint,
                                  isPassword: true,
                                  validator: Validators.validatePassword,
                                ),
                                const SizedBox(height: 10),

                                // Forgot Password link
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () =>
                                        context.push(AppRoutes.forgotPassword),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6.0,
                                      ),
                                      child: Text(
                                        AuthStrings.forgotPasswordLink,
                                        style: TextStyle(
                                          color:
                                              onboardingColors.welcomeHighlight,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Primary Sign In Button
                                SignalBuilder(
                                  builder: (context) {
                                    final isLoading =
                                        appComponent.authSignal.status.value ==
                                            AuthStatus.loading;

                                    return AuthPrimaryButton(
                                      text: AuthStrings.signInButton,
                                      isLoading: isLoading,
                                      onPressed: _signIn,
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Mindful OR Divider
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: onboardingColors.welcomeSubtitle
                                            .withValues(alpha: 0.2),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14.0,
                                      ),
                                      child: Text(
                                        AuthStrings.orDivider,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              onboardingColors.welcomeSubtitle,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: onboardingColors.welcomeSubtitle
                                            .withValues(alpha: 0.2),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Google Sign-In Button
                                SignalBuilder(
                                  builder: (context) {
                                    final isLoading =
                                        appComponent.authSignal.status.value ==
                                            AuthStatus.loading;

                                    return AuthGoogleButton(
                                      isLoading: isLoading,
                                      onPressed: () async {
                                        final success = await appComponent
                                            .authSignal
                                            .signInWithGoogle();
                                        if (!context.mounted || success) {
                                          return;
                                        }
                                        final message = appComponent
                                            .authSignal
                                            .errorMessage
                                            .value;
                                        if (message != null) {
                                          SnackBarUtils.showError(
                                            context,
                                            message,
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Switch to Sign Up row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AuthStrings.dontHaveAccount,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: onboardingColors.welcomeSubtitle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => context.push(AppRoutes.signUp),
                                child: Text(
                                  AuthStrings.signUpAction,
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
            );
          },
        ),
      ),
    );
  }
}