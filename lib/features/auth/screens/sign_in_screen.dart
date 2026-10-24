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
import '../widgets/auth_trust_badge.dart';

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
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      await appComponent.authSignal.handleSignIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
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
                            context.go(AppRoutes.welcome);
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
                            title: AuthStrings.signInTitle,
                            subtitle: AuthStrings.signInSubtitle,
                          ),
                          const SizedBox(height: 24),

                          // Form Card grouping inputs and primary action
                          AuthCard(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomTextField(
                                    controller: _emailController,
                                    label: AuthStrings.emailLabel,
                                    hintText: AuthStrings.emailHint,
                                    prefixIcon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: Validators.validateEmail,
                                  ),
                                  const SizedBox(height: 18),
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
                                    validator: Validators.validatePassword,
                                  ),
                                  const SizedBox(height: 12),

                                  // Forgot Password link
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () =>
                                          context.push(AppRoutes.forgotPassword),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                        ),
                                        child: Text(
                                          AuthStrings.forgotPasswordLink,
                                          style: TextStyle(
                                            color:
                                                onboardingColors.welcomeHighlight,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
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
