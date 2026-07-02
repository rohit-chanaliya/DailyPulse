import 'package:flutter/material.dart';
import 'package:dailypulse/core/theme/colors.dart';
import 'four_circle_logo.dart';
import '../providers/splash_provider.dart';

class BrandLogoPhase extends StatelessWidget {
  const BrandLogoPhase({super.key});

  @override
  Widget build(BuildContext context) {
    const brandColor = AppColors.splashCreamBrand; // Terracotta/Brown
    return Container(
      key: const ValueKey(SplashPhase.brandLogo),
      color: AppColors.splashCreamBg, // Creamy Off-white
      width: double.infinity,
      height: double.infinity,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FourCircleLogo(
              size: 80,
              color: brandColor,
            ),
            SizedBox(height: 24),
            Text(
              'dailypulse.ai',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: brandColor,
                letterSpacing: -1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
