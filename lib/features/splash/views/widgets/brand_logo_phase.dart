import 'package:flutter/material.dart';
import 'package:dailypulse/core/theme/theme_extension.dart';
import 'four_circle_logo.dart';
import '../../viewmodels/splash_viewmodel.dart';

class BrandLogoPhase extends StatelessWidget {
  const BrandLogoPhase({super.key});

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).extension<AppThemeExtension>()!;

    return Container(
      key: const ValueKey(SplashPhase.brandLogo),
      color: customTheme.splashBrandLogoBg,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FourCircleLogo(
              size: 80,
              color: customTheme.splashBrandLogoColor,
            ),
            const SizedBox(height: 24),
            Text(
              'dailypulse.ai',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: customTheme.splashBrandLogoColor,
                letterSpacing: -1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
