import 'package:flutter/material.dart';
import 'package:dailypulse/core/constant/strings/onboarding_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/widgets/app_logo_widget.dart';

/// Central hero visual spotlighting the official yoga app logo flanked by mental health benefits.
class WelcomeHeroVisual extends StatelessWidget {
  const WelcomeHeroVisual({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingColors = context.onboarding;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final isCompact = availableWidth < 340;

        return Center(
          child: SizedBox(
            height: 310,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. Concentric Aura Background
                const _AuraRings(),

                // 2. Center Yoga App Logo Halo
                const _CenterLogoHalo(),

                // 3. Flanking Mental Health Points (Left & Right)
                // Left 1: Mindful Calm (assets/mindfull/leaf.png)
                Positioned(
                  left: isCompact ? 0 : 4,
                  top: 24,
                  child: _MentalHealthPointCard(
                    assetPath: 'assets/mindfull/leaf.png',
                    accentColor: onboardingColors.page1Highlight,
                    title: OnboardingStrings.welcomePointCalmTitle,
                    subtitle: OnboardingStrings.welcomePointCalmSubtitle,
                  ),
                ),

                // Left 2: Mood Patterns (assets/mindfull/chart_1.png)
                Positioned(
                  left: isCompact ? 0 : 4,
                  bottom: 24,
                  child: _MentalHealthPointCard(
                    assetPath: 'assets/mindfull/chart_1.png',
                    accentColor: onboardingColors.page2Highlight,
                    title: OnboardingStrings.welcomePointMoodTitle,
                    subtitle: OnboardingStrings.welcomePointMoodSubtitle,
                  ),
                ),

                // Right 1: Inner Joy (assets/mindfull/mood_happy.png)
                Positioned(
                  right: isCompact ? 0 : 4,
                  top: 24,
                  child: _MentalHealthPointCard(
                    assetPath: 'assets/mindfull/mood_happy.png',
                    accentColor: onboardingColors.page3Highlight,
                    title: OnboardingStrings.welcomePointBalanceTitle,
                    subtitle: OnboardingStrings.welcomePointBalanceSubtitle,
                  ),
                ),

                // Right 2: Self Care (assets/mindfull/head_heart.png)
                Positioned(
                  right: isCompact ? 0 : 4,
                  bottom: 24,
                  child: _MentalHealthPointCard(
                    assetPath: 'assets/mindfull/head_heart.png',
                    accentColor: onboardingColors.page4Highlight,
                    title: OnboardingStrings.welcomePointSelfCareTitle,
                    subtitle: OnboardingStrings.welcomePointSelfCareSubtitle,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Concentric ambient aura behind the central logo.
class _AuraRings extends StatelessWidget {
  const _AuraRings();

  @override
  Widget build(BuildContext context) {
    final highlight = context.onboarding.welcomeHighlight;

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 270,
            height: 270,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: highlight.withValues(alpha: 0.04),
            ),
          ),
          Container(
            width: 210,
            height: 210,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: highlight.withValues(alpha: 0.07),
            ),
          ),
          Container(
            width: 155,
            height: 155,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: highlight.withValues(alpha: 0.11),
            ),
          ),
        ],
      ),
    );
  }
}

/// Central circular halo housing the official yoga emblem.
class _CenterLogoHalo extends StatelessWidget {
  const _CenterLogoHalo();

  @override
  Widget build(BuildContext context) {
    final onboardingColors = context.onboarding;
    final cardColors = context.cards;

    return Container(
      width: 132,
      height: 132,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: cardColors.statsCard,
        border: Border.all(
          color: onboardingColors.welcomeHighlight.withValues(alpha: 0.35),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: cardColors.shadow,
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Center(
        child: AppLogoWidget(size: 96),
      ),
    );
  }
}

/// Compact mental health benefit card leveraging the app's custom curated assets.
class _MentalHealthPointCard extends StatelessWidget {
  final String assetPath;
  final Color accentColor;
  final String title;
  final String subtitle;

  const _MentalHealthPointCard({
    required this.assetPath,
    required this.accentColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cardColors = context.cards;
    final onboardingColors = context.onboarding;

    return Container(
      width: 114,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cardColors.statsCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: onboardingColors.welcomeSubtitle.withValues(alpha: 0.16),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: cardColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withValues(alpha: 0.18),
            ),
            child: Center(
              child: Image.asset(
                assetPath,
                width: 15,
                height: 15,
                color: accentColor,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: onboardingColors.welcomeText,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: onboardingColors.welcomeSubtitle,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
