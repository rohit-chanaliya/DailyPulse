import 'package:flutter/material.dart';
import 'package:dailypulse/core/theme/app_theme.dart';
import 'four_circle_logo.dart';
import '../../viewmodels/splash_viewmodel.dart';

class QuotePhase extends StatelessWidget {
  final VoidCallback onContinue;

  const QuotePhase({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final splashColors = context.splash;

    return Container(
      key: const ValueKey(SplashPhase.quote),
      color: splashColors.quoteBg,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          FourCircleLogo(
            size: 60,
            color: splashColors.quoteText,
          ),
          const Spacer(flex: 2),
          Text(
            '"In the midst of winter, I found there was within me an invincible summer."',
            textAlign: TextAlign.center,
            style: context.textTheme.titleLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: splashColors.quoteText,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '— ALBERT CAMUS',
            style: context.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: splashColors.quoteText.withValues(alpha: 0.8),
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
                    color: splashColors.quoteText.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: IconButton(
                  iconSize: 28,
                  padding: const EdgeInsets.all(12),
                  icon: Icon(
                    Icons.arrow_forward_rounded,
                    color: splashColors.quoteText,
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
