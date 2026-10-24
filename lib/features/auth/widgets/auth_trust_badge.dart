import 'package:flutter/material.dart';
import 'package:dailypulse/core/constant/strings/auth_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';

/// Subtle mindful trust and privacy badge emphasizing DailyPulse's offline-first design.
class AuthTrustBadge extends StatelessWidget {
  const AuthTrustBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingColors = context.onboarding;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: onboardingColors.welcomeSubtitle.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: onboardingColors.welcomeSubtitle.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 14,
            color: onboardingColors.welcomeHighlight,
          ),
          const SizedBox(width: 8),
          Text(
            AuthStrings.privacyPromise,
            style: context.textTheme.labelSmall?.copyWith(
              color: onboardingColors.welcomeSubtitle,
              fontWeight: FontWeight.w500,
              fontSize: 11,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
