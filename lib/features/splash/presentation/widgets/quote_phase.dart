import 'package:flutter/material.dart';
import 'package:dailypulse/core/theme/colors.dart';
import 'four_circle_logo.dart';
import '../providers/splash_provider.dart';

class QuotePhase extends StatelessWidget {
  final VoidCallback onContinue;

  const QuotePhase({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey(SplashPhase.quote),
      color: AppColors.splashOrangeBg, // Terracotta Orange
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          const FourCircleLogo(
            size: 60,
            color: Colors.white,
          ),
          const Spacer(flex: 2),
          const Text(
            '"In the midst of winter, I found there was within me an invincible summer."',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: Colors.white,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '— ALBERT CAMUS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.white.withValues(alpha: 0.8),
              letterSpacing: 2.0,
            ),
          ),
          const Spacer(flex: 3),
          // Clean custom Continue button at the bottom
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: IconButton(
                  iconSize: 28,
                  padding: const EdgeInsets.all(12),
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
                  onPressed: onContinue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
