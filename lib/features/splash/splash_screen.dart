import 'package:dailypulse/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../shared/navigation/fade_page_route.dart';
import '../auth/widgets/auth_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _navigateToAuth() {
    Navigator.of(context).pushReplacement(
      FadePageRoute(
        page: const AuthWrapper(),
        duration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.filter_vintage,
                    color: AppTheme.accentPink,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'DailyPulse',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentPink,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // Illustration
              Image.asset(
                'assets/images/onboarding_family.png',
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if image not found
                  return const Icon(
                    Icons.image_not_supported,
                    size: 100,
                    color: Colors.grey,
                  );
                },
              ),

              const Spacer(flex: 2),

              // Title and Subtitle
              Text(
                'Your Path to Mental\nWellness Begins Here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Discover Personalized Support and Resources\nTailored to Your Well-being',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),

              const Spacer(flex: 3),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _navigateToAuth,
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _navigateToAuth,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: const Text('I Have an Account'),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
