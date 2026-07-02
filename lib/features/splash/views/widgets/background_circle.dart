import 'package:flutter/material.dart';

class BackgroundCircle extends StatelessWidget {
  final double diameter;
  final Color color;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const BackgroundCircle({
    super.key,
    required this.diameter,
    required this.color,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      width: diameter,
      height: diameter,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
