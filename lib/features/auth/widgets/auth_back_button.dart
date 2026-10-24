import 'package:flutter/material.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';

/// Reusable circular back navigation button for authentication screens.
class AuthBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AuthBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final onboardingColors = context.onboarding;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: onboardingColors.welcomeSubtitle.withValues(alpha: 0.08),
        border: Border.all(
          color: onboardingColors.welcomeSubtitle.withValues(alpha: 0.16),
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(
          Icons.chevron_left_rounded,
          color: onboardingColors.welcomeText,
          size: 24,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
