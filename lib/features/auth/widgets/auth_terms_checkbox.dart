import 'package:flutter/material.dart';
import 'package:dailypulse/core/constant/strings/auth_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';

/// Interactive Terms & Conditions checkbox for the Sign Up screen.
class AuthTermsCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const AuthTermsCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final onboardingColors = context.onboarding;

    return GestureDetector(
      onTap: () => onChanged(!isChecked),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isChecked
                  ? onboardingColors.welcomeHighlight
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isChecked
                    ? onboardingColors.welcomeHighlight
                    : onboardingColors.welcomeSubtitle.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: isChecked
                ? const Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: context.textTheme.bodySmall?.copyWith(
                  color: onboardingColors.welcomeSubtitle,
                ),
                children: [
                  const TextSpan(text: AuthStrings.termsPrefix),
                  TextSpan(
                    text: AuthStrings.termsLink,
                    style: TextStyle(
                      color: onboardingColors.welcomeHighlight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
