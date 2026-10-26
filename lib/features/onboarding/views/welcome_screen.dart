import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/constant/strings/onboarding_strings.dart';
import 'widgets/welcome_hero_visual.dart';

/// Minimalist welcome screen with central app emblem and key mental health pillars.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _openSignIn(BuildContext context) async {
    await appComponent.onboardingSignal.complete();
    if (context.mounted) {
      context.go(AppRoutes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardingColors = context.onboarding;

    return Scaffold(
      backgroundColor: onboardingColors.welcomeBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Main Headline
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: onboardingColors.welcomeText,
                    height: 1.25,
                    letterSpacing: -0.5,
                  ),
                  children: [
                    const TextSpan(text: OnboardingStrings.welcomeTitlePart1),
                    TextSpan(
                      text: OnboardingStrings.welcomeTitleHighlight,
                      style: TextStyle(
                        color: onboardingColors.welcomeHighlight,
                      ),
                    ),
                    const TextSpan(text: OnboardingStrings.welcomeTitlePart2),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Mindful Subtitle
              Text(
                OnboardingStrings.welcomeSubtitle,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: onboardingColors.welcomeSubtitle,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              // Centerpiece: Yoga Logo + Flanking Mental Health Points
              const Expanded(child: Center(child: WelcomeHeroVisual())),
              const SizedBox(height: 20),
              // Get Started CTA Button
              ElevatedButton(
                onPressed: () => context.push(AppRoutes.onboarding),
                style: ElevatedButton.styleFrom(
                  backgroundColor: onboardingColors.welcomeHighlight,
                  foregroundColor: onboardingColors.welcomeButtonText,
                  minimumSize: const Size(double.infinity, 56),
                  elevation: 6,
                  shadowColor: onboardingColors.welcomeHighlight.withValues(
                    alpha: 0.45,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      OnboardingStrings.welcomeGetStarted,
                      style: context.textTheme.titleLarge?.copyWith(
                        color: onboardingColors.welcomeButtonText,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Already have an account row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    OnboardingStrings.welcomeAlreadyHaveAccount,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: onboardingColors.welcomeSubtitle,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openSignIn(context),
                    child: Text(
                      OnboardingStrings.welcomeSignIn,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: onboardingColors.welcomeHighlight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
