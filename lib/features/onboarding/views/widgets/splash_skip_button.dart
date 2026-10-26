import 'package:dailypulse/core/constant/strings/onboarding_strings.dart';
import 'package:dailypulse/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../viewmodels/splash_signal.dart';
import '../splash_phase_colors.dart';

class SplashSkipButton extends StatelessWidget {
  const SplashSkipButton({
    super.key,
    required this.phase,
    required this.onPressed,
  });

  final SplashPhase phase;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: TextButton(
        key: ValueKey(phase),
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: context.splash.skipButtonFor(phase),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              OnboardingStrings.splashSkip,
              style: context.textTheme.labelMedium,
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
