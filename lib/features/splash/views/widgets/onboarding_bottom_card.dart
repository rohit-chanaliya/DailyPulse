import 'package:flutter/material.dart';
import 'package:dailypulse/core/theme/app_theme.dart';
import 'package:dailypulse/core/theme/colors/app_colors.dart';

class OnboardingBottomCard extends StatelessWidget {
  final int step;
  final String titlePart1;
  final String highlightedTitle;
  final String titlePart2;
  final Color highlightColor;
  final Color badgeColor;
  final VoidCallback onNext;

  const OnboardingBottomCard({
    super.key,
    required this.step,
    required this.titlePart1,
    required this.highlightedTitle,
    required this.titlePart2,
    required this.highlightColor,
    required this.badgeColor,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 40),
      decoration: const BoxDecoration(
        color: AppColors.gray100, // Very dark background like the design
        borderRadius: BorderRadius.vertical(
          top: Radius.elliptical(250, 40), // Creates the curved convex shape
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Step Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.8), // Translucent badge
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'STEP $step',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Title
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: context.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
              children: [
                if (titlePart1.isNotEmpty) TextSpan(text: titlePart1),
                TextSpan(
                  text: highlightedTitle,
                  style: TextStyle(color: highlightColor),
                ),
                if (titlePart2.isNotEmpty) TextSpan(text: titlePart2),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Next Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onNext,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.brown70, // Brown button for consistency as per design
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
