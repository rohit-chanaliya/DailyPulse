import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dailypulse/core/constant/strings/auth_strings.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'auth_card.dart';
import 'auth_primary_button.dart';

/// Shown when a password reset link is invalid or expired.
class ResetLinkError extends StatelessWidget {
  final String message;

  const ResetLinkError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      child: Column(
        children: [
          Icon(
            Icons.link_off_rounded,
            size: 48,
            color: context.onboarding.welcomeHighlight,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.onboarding.welcomeSubtitle,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          AuthPrimaryButton(
            text: AuthStrings.sendResetLinkButton,
            isLoading: false,
            onPressed: () => context.go(AppRoutes.forgotPassword),
          ),
        ],
      ),
    );
  }
}
