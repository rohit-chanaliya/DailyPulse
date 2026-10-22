import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/services/app_preferences.dart';
import 'package:dailypulse/core/theme/app_theme.dart';
import 'package:dailypulse/core/constant/strings/onboarding_strings.dart';

import 'package:dailypulse/core/widgets/app_logo_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _openSignIn(BuildContext context) async {
    await AppPreferences.setHasSeenOnboarding(true);
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
              const SizedBox(height: 16),
              // Logo
              const AppLogoWidget(size: 48),
              const SizedBox(height: 24),
              // Title
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: onboardingColors.welcomeText,
                    height: 1.2,
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
              const SizedBox(height: 16),
              // Subtitle
              Text(
                OnboardingStrings.welcomeSubtitle,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: onboardingColors.welcomeSubtitle,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              // Graphic
              SvgPicture.asset(
                'assets/svg/welcome_1.svg',
                height: 320,
                fit: BoxFit.contain,
              ),
              const Spacer(),
              // Get Started Button
              ElevatedButton(
                onPressed: () => context.push(AppRoutes.onboarding),
                style: ElevatedButton.styleFrom(
                  backgroundColor: onboardingColors.welcomeHighlight,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      OnboardingStrings.welcomeGetStarted,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Sign In Text
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
