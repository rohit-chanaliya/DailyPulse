import 'package:flutter/material.dart';
import 'package:dailypulse/core/theme/app_theme.dart';
import 'four_circle_logo.dart';
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
            FourCircleLogo(
              size: 80,
              color: splashColors.brandLogoColor,
            ),
            const SizedBox(height: 24),
            Text(
              'dailypulse.ai',
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: splashColors.brandLogoColor,
                letterSpacing: -1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
