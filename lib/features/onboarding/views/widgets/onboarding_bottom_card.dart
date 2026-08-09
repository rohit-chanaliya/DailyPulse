import 'package:flutter/material.dart';
import 'package:dailypulse/core/theme/app_theme.dart';
import 'package:dailypulse/core/constant/strings/onboarding_strings.dart';

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
    final colors = context.onboarding;

    return ClipPath(
      clipper: _TopArcClipper(arcHeight: 40),
      child: Container(
        width: double.infinity,
        height: 320,
        // Increased top padding to account for the arc height
        padding: const EdgeInsets.fromLTRB(32, 60, 32, 40),
        decoration: BoxDecoration(
          color: colors.bottomCardBg,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Column(
            key: ValueKey(step),
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
                '${OnboardingStrings.onboardingStepPrefix} $step',
                style: TextStyle(
                  color: colors.bottomCardBadgeText,
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
                  color: colors.bottomCardText,
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
                  decoration: BoxDecoration(
                    color: colors.bottomCardButtonBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: colors.bottomCardButtonIcon,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
        ),
      ),
    );
  }
}

class _TopArcClipper extends CustomClipper<Path> {
  final double arcHeight;

  _TopArcClipper({required this.arcHeight});

  @override
  Path getClip(Size size) {
    final path = Path();
    // Start at left edge, below the top by 'arcHeight'
    path.moveTo(0, arcHeight);

    // Create a smooth bezier curve that reaches y=0 at the center
    // For a quadratic bezier to reach exactly y=0 when passing through (0, h) and (w, h),
    // the control point must be at y = -h.
    path.quadraticBezierTo(size.width / 2, -arcHeight, size.width, arcHeight);

    // Draw lines to the bottom corners to complete the shape
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant _TopArcClipper oldClipper) {
    return oldClipper.arcHeight != arcHeight;
  }
}
