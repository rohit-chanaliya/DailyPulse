import 'package:flutter/material.dart';

class FourCircleLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final bool isBadge;

  const FourCircleLogo({
    super.key,
    this.size = 64,
    this.color,
    this.isBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? const Color(0xFF8D5B4C);

    final logoWidget = CustomPaint(
      size: Size(size, size),
      painter: _FourCirclePainter(color: effectiveColor),
    );

    if (isBadge) {
      return Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size * 0.18),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: logoWidget,
      );
    }

    return SizedBox(width: size, height: size, child: logoWidget);
  }
}

/// Draws four rounded circles in a 2×2 grid — matching the design spec icon.
class _FourCirclePainter extends CustomPainter {
  final Color color;

  const _FourCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double circleRadius = size.width * 0.28;
    final double gap = size.width * 0.04;
    final double cx = size.width / 2;
    final double cy = size.height / 2;

    // Top-left circle
    canvas.drawCircle(
      Offset(cx - circleRadius - gap / 2, cy - circleRadius - gap / 2),
      circleRadius,
      paint,
    );
    // Top-right circle
    canvas.drawCircle(
      Offset(cx + circleRadius + gap / 2, cy - circleRadius - gap / 2),
      circleRadius,
      paint,
    );
    // Bottom-left circle
    canvas.drawCircle(
      Offset(cx - circleRadius - gap / 2, cy + circleRadius + gap / 2),
      circleRadius,
      paint,
    );
    // Bottom-right circle
    canvas.drawCircle(
      Offset(cx + circleRadius + gap / 2, cy + circleRadius + gap / 2),
      circleRadius,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _FourCirclePainter oldDelegate) =>
      oldDelegate.color != color;
}
