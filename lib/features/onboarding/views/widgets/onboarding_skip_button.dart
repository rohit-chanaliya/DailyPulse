import 'package:dailypulse/core/constant/strings/onboarding_strings.dart';
import 'package:dailypulse/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: context.onboarding.indicatorActive,
      ),
      child: const Text(OnboardingStrings.onboardingSkip),
    );
  }
}
