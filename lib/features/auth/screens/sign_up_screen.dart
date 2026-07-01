import 'package:dailypulse/app/theme/colors.dart';
import 'package:dailypulse/app/theme/typography.dart';
import 'package:dailypulse/features/auth/presentation/providers/auth_provider.dart';
import 'package:dailypulse/features/auth/widgets/auth_custom_widgets.dart';
import 'package:dailypulse/shared/navigation/fade_page_route.dart';
import 'package:dailypulse/core/utils/snackbar_utils.dart';
import 'package:dailypulse/core/utils/validators.dart';
import 'package:dailypulse/core/widgets/custom_text_field.dart';
import 'package:dailypulse/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'sign_in_screen.dart';

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
  bool _showEmailErrorBanner = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    // 1. Reset email error state
    setState(() {
      _showEmailErrorBanner = false;
    });

    // 2. Validate email format specifically to trigger mockup error banner
    final emailVal = Validators.validateEmail(_emailController.text);
    if (emailVal != null) {
      setState(() {
        _showEmailErrorBanner = true;
      });
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        SnackBarUtils.showError(context, 'You must agree to the Terms & Conditions');
        return;
      }

      final authProvider = context.read<AuthProvider>();
      await authProvider.handleSignUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        onSuccess: () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              FadePageRoute(page: const SignInScreen()),
            );
            SnackBarUtils.showSuccess(context, 'Account created successfully!');
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
                      'Sign Up For Free',
                      style: AppTypography.heading2xlBold.copyWith(
                        color: isDark ? Colors.white : const Color(0xFF402B20), // dark brown title
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Full Name Field (Helper for registration completeness)
                    CustomTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hintText: 'Enter your name...',
                      prefixIcon: Icons.person_outline_rounded,
                      validator: Validators.validateName,
                    ),
                    const SizedBox(height: 20),

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

                    // Mockup Warning Banner for Invalid Email (drawn matching sign_up image)
                    if (_showEmailErrorBanner) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF421C15) : const Color(0xFFFEDCD6), // soft red/pink alert
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isDark ? const Color(0xFF6B2014) : const Color(0xFFFEADA0),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: isDark ? const Color(0xFFFF8B78) : const Color(0xFFD32F2F),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Invalid Email Address!!',
                              style: AppTypography.textXsBold.copyWith(
                                color: isDark ? const Color(0xFFFF8B78) : const Color(0xFFD32F2F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                      validator: Validators.validatePasswordStrength,
                    ),
                    const SizedBox(height: 24),

                    // I Agree Terms & Conditions Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          activeColor: AppColors.splashGreenBg,
                          checkColor: Colors.white,
                          onChanged: (val) {
                            setState(() {
                              _agreeToTerms = val ?? false;
                            });
                          },
                        ),
                        Text(
                          'I Agree with the ',
                          style: AppTypography.textXsMedium.copyWith(
                            color: isDark ? Colors.grey.shade400 : const Color(0xFF5A4535),
                          ),
                        ),
                        Text(
                          'Terms & Conditions',
                          style: AppTypography.textXsBold.copyWith(
                            color: AppColors.splashGreenBg,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Sign Up Button
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return AppButton(
                          text: 'Sign Up',
                          suffixIcon: Icons.arrow_forward_rounded,
                          isLoading: authProvider.status == AuthStatus.loading,
                          onPressed: _signUp,
                        );
                      },
                    ),
                    const SizedBox(height: 36),

                    // Navigation back to Sign In
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTypography.paragraphSm.copyWith(
                            color: isDark ? Colors.grey.shade400 : const Color(0xFF5A4535),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              FadePageRoute(page: const SignInScreen()),
                            );
                          },
                          child: Text(
                            'Sign In.',
                            style: AppTypography.textSmBold.copyWith(
                              color: AppColors.splashOrangeBg,
                            ),
                          ),
                        ),
                      ],
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
