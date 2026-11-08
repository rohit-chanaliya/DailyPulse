import 'package:flutter/material.dart';

/// Banner whose lower edge is the arc of a large circle ending at [bottom].
class CurvedBanner extends StatelessWidget {
  const CurvedBanner({super.key, required this.color, required this.bottom});

  final Color color;

  /// Y position of the arc's lowest point, in the parent's coordinates.
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BannerPainter(color: color, bottom: bottom));
  }
}

class _BannerPainter extends CustomPainter {
  const _BannerPainter({required this.color, required this.bottom});

  final Color color;
  final double bottom;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width * 0.96;
    canvas.drawCircle(
      Offset(size.width / 2, bottom - radius),
      radius,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_BannerPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.bottom != bottom;
}
