import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';

/// Green banner with soft decorative shapes behind the feedback sheet.
class FeedbackBanner extends StatelessWidget {
  const FeedbackBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return ColoredBox(
      color: home.green,
      child: CustomPaint(
        painter: _ShapesPainter(
          dark: home.greenDark.withValues(alpha: 0.35),
          light: home.greenLight.withValues(alpha: 0.4),
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _ShapesPainter extends CustomPainter {
  const _ShapesPainter({required this.dark, required this.light});

  final Color dark;
  final Color light;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = dark;
    final ring = Paint()
      ..color = dark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final arc = Paint()
      ..color = light
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(const Offset(-6, 80), 30, fill);
    canvas.drawCircle(Offset(size.width - 60, size.height - 90), 40, ring);
    canvas.drawCircle(Offset(size.width * 0.62, size.height * 0.4), 12, Paint()..color = light);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 0.38, 18), radius: 44),
      3.4,
      3.0,
      false,
      arc,
    );
    canvas.drawLine(
      Offset(24, size.height - 40),
      Offset(size.width * 0.3, size.height - 110),
      ring..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ShapesPainter oldDelegate) =>
      oldDelegate.dark != dark || oldDelegate.light != light;
}
