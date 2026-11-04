import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/links.dart';
import 'package:dailypulse/core/constant/strings/auth_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/link_launcher.dart';

/// Terms & Conditions consent checkbox with working policy links.
class AuthTermsCheckbox extends StatefulWidget {
  const AuthTermsCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
  });

  final bool isChecked;
  final ValueChanged<bool> onChanged;

  @override
  State<AuthTermsCheckbox> createState() => _AuthTermsCheckboxState();
}

class _AuthTermsCheckboxState extends State<AuthTermsCheckbox> {
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () => LinkLauncher.open(context, AppLinks.termsOfService);
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => LinkLauncher.open(context, AppLinks.privacyPolicy);
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingColors = context.onboarding;

    final linkStyle = TextStyle(
      color: onboardingColors.welcomeHighlight,
      fontWeight: FontWeight.w700,
    );

    return GestureDetector(
      onTap: () => widget.onChanged(!widget.isChecked),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: widget.isChecked
                  ? onboardingColors.welcomeHighlight
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: widget.isChecked
                    ? onboardingColors.welcomeHighlight
                    : onboardingColors.welcomeSubtitle.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: widget.isChecked
                ? Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: onboardingColors.welcomeButtonText,
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
                    style: linkStyle,
                    recognizer: _termsRecognizer,
                  ),
                  const TextSpan(text: AuthStrings.termsAndPrivacyDivider),
                  TextSpan(
                    text: AuthStrings.privacyPolicyLink,
                    style: linkStyle,
                    recognizer: _privacyRecognizer,
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
