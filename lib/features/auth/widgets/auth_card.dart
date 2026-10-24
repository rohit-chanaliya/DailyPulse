import 'package:flutter/material.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';

/// Elevated mindful card container providing structure, depth, and framing for auth forms.
class AuthCard extends StatelessWidget {
  final Widget child;

  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final onboardingColors = context.onboarding;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: onboardingColors.welcomeSubtitle.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: onboardingColors.welcomeSubtitle.withValues(alpha: 0.12),
          width: 1.2,
        ),
      ),
      child: child,
    );
  }
}
