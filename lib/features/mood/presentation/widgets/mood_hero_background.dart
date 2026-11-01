import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Hero panel whose bottom edge bulges downward, filled with topographic lines.
class MoodHeroBackground extends StatelessWidget {
  const MoodHeroBackground({
    super.key,
    required this.color,
    required this.lineColor,
    required this.child,
  });

  final Color color;
  final Color lineColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: const _HeroClipper(),
      child: ColoredBox(
        color: color,
        child: CustomPaint(
          painter: _ContourPainter(lineColor),
          child: child,
        ),
      ),
    );
  }
}

class _HeroClipper extends CustomClipper<Path> {
  const _HeroClipper();

  static const double _rise = 56;

  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - _rise)
      ..quadraticBezierTo(
        size.width / 2,
        size.height + _rise,
        size.width,
        size.height - _rise,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(_HeroClipper old) => false;
}

class _ContourPainter extends CustomPainter {
  _ContourPainter(this.color);

  final Color color;

  static const int _lines = 18;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (var i = 0; i < _lines; i++) {
      final t = i / (_lines - 1);
      final x = -size.width * 0.2 + size.width * 1.4 * t;
      final sway = 40 * math.sin(t * math.pi * 2 + 0.6);
      canvas.drawPath(
        Path()
          ..moveTo(x, 0)
          ..cubicTo(
            x + 70 + sway,
            size.height * 0.3,
            x - 50 - sway,
            size.height * 0.65,
            x + 30 * (1 - t),
            size.height,
          ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ContourPainter old) => old.color != color;
}
