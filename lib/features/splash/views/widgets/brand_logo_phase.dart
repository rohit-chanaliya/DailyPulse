import 'package:flutter/material.dart';
import 'package:dailypulse/core/theme/app_theme.dart';
import '../../viewmodels/splash_viewmodel.dart';

class BrandLogoPhase extends StatelessWidget {
  const BrandLogoPhase({super.key});

  @override
  Widget build(BuildContext context) {
    final splashColors = context.splash;

    return Container(
      key: const ValueKey(SplashPhase.brandLogo),
      color: splashColors.brandLogoBg,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/mindful_yoga_logo.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),

            Text(
              'dailypulse.ai',
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: splashColors.brandLogoColor,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
