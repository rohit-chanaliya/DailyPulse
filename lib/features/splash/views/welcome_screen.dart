import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dailypulse/core/theme/app_theme.dart';
import 'package:dailypulse/core/theme/colors/app_colors.dart';
import 'package:dailypulse/features/auth/screens/sign_in_screen.dart';
import 'package:dailypulse/features/splash/views/onboarding_screen.dart';
import 'package:dailypulse/core/widgets/navigation/fade_page_route.dart';
import 'package:dailypulse/core/widgets/app_logo_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use shade 80 for the background color as requested
    final backgroundColor = AppColors.gray80;

    return Scaffold(
      backgroundColor: backgroundColor,
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
                    color: Colors.white,
                    height: 1.2,
                  ),
                  children: const [
                    TextSpan(text: 'Welcome to the ultimate\n'),
                    TextSpan(
                      text: 'freud',
                      style: TextStyle(color: AppColors.orange60),
                    ),
                    TextSpan(text: ' UI Kit!'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle
              Text(
                'Your mindful mental health AI companion\nfor everyone anywhere \u2714',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
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
                onPressed: () {
                  Navigator.of(context).push(
                    FadePageRoute(page: const OnboardingScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange60,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Get Started', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
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
                    'Already have an account? ',
                    style: context.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        FadePageRoute(page: const SignInScreen()),
                      );
                    },
                    child: Text(
                      'Sign In',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.orange60,
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
