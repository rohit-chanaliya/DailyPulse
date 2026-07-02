import 'package:flutter/material.dart';
import 'package:dailypulse/core/theme/colors.dart';
import 'background_circle.dart';
import '../providers/splash_provider.dart';

class ProgressLoadingPhase extends StatelessWidget {
  final double progressValue;

  const ProgressLoadingPhase({
    super.key,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    const circleColor = AppColors.splashDarkOverlay;

    return Container(
      key: const ValueKey(SplashPhase.progressLoading),
      color: AppColors.splashDarkBg, // Deep Dark Brown
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background overlapping circles
          BackgroundCircle(
            diameter: width * 0.9,
            color: circleColor,
            top: -width * 0.35,
            left: width * 0.05,
          ),
          BackgroundCircle(
            diameter: width * 0.72,
            color: circleColor,
            top: height * 0.28,
            left: -width * 0.36,
          ),
          BackgroundCircle(
            diameter: width * 0.72,
            color: circleColor,
            top: height * 0.34,
            right: -width * 0.36,
          ),
          BackgroundCircle(
            diameter: width * 0.9,
            color: circleColor,
            bottom: -width * 0.35,
            left: width * 0.05,
          ),

          // Central Percentage Text
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  progressValue.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 84,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -2.0,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  '%',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
