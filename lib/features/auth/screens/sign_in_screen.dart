import 'package:dailypulse/core/theme/colors.dart';
import 'package:dailypulse/core/theme/typography.dart';
import 'package:dailypulse/features/auth/presentation/providers/auth_provider.dart';
import 'package:dailypulse/features/auth/widgets/auth_custom_widgets.dart';
import 'package:dailypulse/shared/navigation/fade_page_route.dart';
import 'package:dailypulse/core/utils/snackbar_utils.dart';
import 'package:dailypulse/core/utils/validators.dart';
import 'package:dailypulse/core/widgets/custom_text_field.dart';
import 'package:dailypulse/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';

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
      final authProvider = context.read<AuthProvider>();
      await authProvider.handleSignIn(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF161210) : AppColors.splashCreamBg, // cream bg matching mockup
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Curved Sage Green Header
            const CurvedHeader(),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Title
                    Text(
                      'Sign In To dailypulse.ai',
                      style: AppTypography.heading2xlBold.copyWith(
                        color: isDark ? Colors.white : const Color(0xFF402B20), // dark brown title
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Email Address Field
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hintText: 'Enter your email...',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isDark ? Colors.grey.shade400 : const Color(0xFF5A4535),
                      ),
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hintText: 'Enter your password...',
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18,
                          color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      validator: Validators.validatePassword,
                    ),
                    const SizedBox(height: 32),

                    // Sign In Button
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return AppButton(
                          text: 'Sign In',
                          suffixIcon: Icons.arrow_forward_rounded,
                          isLoading: authProvider.status == AuthStatus.loading,
                          onPressed: _signIn,
                        );
                      },
                    ),
                    const SizedBox(height: 36),

                    // Social Logins
                    const SocialRow(),
                    const SizedBox(height: 36),

                    // Navigation Links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTypography.paragraphSm.copyWith(
                            color: isDark ? Colors.grey.shade400 : const Color(0xFF5A4535),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              FadePageRoute(page: const SignUpScreen()),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: AppTypography.textSmBold.copyWith(
                              color: AppColors.splashOrangeBg, // orange accent
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          FadePageRoute(page: const ForgotPasswordScreen()),
                        );
                      },
                      child: Text(
                        'Forgot Password',
                        style: AppTypography.textSmBold.copyWith(
                          color: AppColors.splashOrangeBg,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
