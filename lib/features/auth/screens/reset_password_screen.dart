import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dailypulse/core/constant/strings/auth_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/snackbar_utils.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_trust_badge.dart';
import '../widgets/reset_link_error.dart';
import '../widgets/reset_password_form.dart';

/// Screen used when a password reset link opens the app directly.
class ResetPasswordScreen extends StatefulWidget {
  final String oobCode;

  const ResetPasswordScreen({super.key, required this.oobCode});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;
  bool _isLoadingEmail = true;
  String? _email;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _loadEmail() async {
    if (widget.oobCode.isEmpty) {
      setState(() {
        _isLoadingEmail = false;
        _loadError = AuthStrings.invalidResetLink;
      });
      return;
    }

    final email = await appComponent.authSignal.verifyPasswordResetCode(
      widget.oobCode,
    );

    if (!mounted) return;
    setState(() {
      _isLoadingEmail = false;
      _email = email;
      _loadError = email == null
          ? (appComponent.authSignal.errorMessage.value ??
                AuthStrings.invalidResetLink)
          : null;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final success = await appComponent.authSignal.confirmPasswordReset(
      oobCode: widget.oobCode,
      newPassword: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      SnackBarUtils.showSuccess(context, AuthStrings.passwordResetSuccess);
      context.go(AppRoutes.signIn);
    } else {
      SnackBarUtils.showError(
        context,
        appComponent.authSignal.errorMessage.value ??
            AuthStrings.invalidResetLink,
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AuthBackButton(
                        onPressed: () => context.go(AppRoutes.signIn),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AuthHeader(
                            title: AuthStrings.resetPasswordTitle,
                            subtitle: AuthStrings.resetPasswordSubtitle,
                          ),
                          const SizedBox(height: 12),
                          if (_isLoadingEmail)
                            const Padding(
                              padding: EdgeInsets.all(24),
                              child: CircularProgressIndicator(),
                            )
                          else if (_loadError != null)
                            ResetLinkError(message: _loadError!)
                          else
                            ResetPasswordForm(
                              formKey: _formKey,
                              email: _email,
                              passwordController: _passwordController,
                              confirmController: _confirmController,
                              obscurePassword: _obscurePassword,
                              isSubmitting: _isSubmitting,
                              onToggleObscure: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              onSubmit: _submit,
                            ),
                        ],
                      ),
                    ),
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
