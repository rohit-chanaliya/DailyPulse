import 'package:flutter/material.dart';
import 'package:dailypulse/core/theme/colors.dart';

class FourCircleLogo extends StatelessWidget {
  final double size;
  final Color color;

  const FourCircleLogo({
    super.key,
    this.size = 64,
    this.color = AppColors.splashCreamBrand,
  });

  @override
  Widget build(BuildContext context) {
    final double circleSize = size * 0.46;
    final double offset = size * 0.17;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Top Circle
          Positioned(
            top: size / 2 - circleSize / 2 - offset,
            child: _circle(circleSize),
          ),
          // Bottom Circle
          Positioned(
            bottom: size / 2 - circleSize / 2 - offset,
            child: _circle(circleSize),
          ),
          // Left Circle
          Positioned(
            left: size / 2 - circleSize / 2 - offset,
            child: _circle(circleSize),
          ),
          // Right Circle
          Positioned(
            right: size / 2 - circleSize / 2 - offset,
            child: _circle(circleSize),
          ),
        ],
      ),
    );
  }

  Widget _circle(double circleSize) {
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
