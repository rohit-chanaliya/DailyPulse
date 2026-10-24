import 'package:flutter/material.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/widgets/app_logo_widget.dart';

/// Unified mindful branding header featuring the app logo, headline, and subtitle.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final onboardingColors = context.onboarding;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const AppLogoWidget(size: 120),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: onboardingColors.welcomeText,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: onboardingColors.welcomeSubtitle,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
