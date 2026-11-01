import 'package:flutter/material.dart';

/// Flat emotion face for a mood level (0 frustrated … 5 excited).
class MoodFace extends StatelessWidget {
  const MoodFace({
    super.key,
    required this.level,
    required this.faceColor,
    required this.featureColor,
    this.size = 160,
  });

  final int level;
  final Color faceColor;
  final Color featureColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _FacePainter(
        level: level,
        faceColor: faceColor,
        featureColor: featureColor,
      ),
    );
  }
}

class _FacePainter extends CustomPainter {
  _FacePainter({
    required this.level,
    required this.faceColor,
    required this.featureColor,
  });

  final int level;
  final Color faceColor;
  final Color featureColor;

  static const _happyLevel = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    Offset p(double x, double y) => Offset(x * s, y * s);

    if (level == _happyLevel) {
      canvas.drawCircle(
        p(0.5, 0.5),
        s * 0.52,
        Paint()
          ..color = faceColor.withValues(alpha: 0.45)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * 0.16),
      );
    }
    canvas.drawCircle(p(0.5, 0.5), s / 2, Paint()..color = faceColor);

    final stroke = Paint()
      ..color = featureColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = s * 0.075;

    void line(Offset a, Offset b) => canvas.drawLine(a, b, stroke);
    void curve(Offset a, Offset c, Offset b) => canvas.drawPath(
      Path()
        ..moveTo(a.dx, a.dy)
        ..quadraticBezierTo(c.dx, c.dy, b.dx, b.dy),
      stroke,
    );
    void pillEyes(double y, double half) {
      for (final x in [0.31, 0.69]) {
        line(p(x, y - half), p(x, y + half));
      }
    }

    switch (level) {
      case 0:
        line(p(0.19, 0.27), p(0.40, 0.36));
        line(p(0.81, 0.27), p(0.60, 0.36));
        pillEyes(0.47, 0.055);
        curve(p(0.34, 0.74), p(0.5, 0.62), p(0.66, 0.74));
      case 1:
        for (final x in [0.31, 0.69]) {
          line(p(x - 0.075, 0.33), p(x + 0.075, 0.47));
          line(p(x + 0.075, 0.33), p(x - 0.075, 0.47));
        }
        curve(p(0.30, 0.74), p(0.5, 0.58), p(0.70, 0.74));
      case 2:
        pillEyes(0.40, 0.075);
        curve(p(0.32, 0.72), p(0.5, 0.58), p(0.68, 0.72));
      case 3:
        pillEyes(0.40, 0.075);
        line(p(0.30, 0.66), p(0.70, 0.66));
      case 4:
        pillEyes(0.40, 0.075);
        curve(p(0.30, 0.60), p(0.5, 0.82), p(0.70, 0.60));
      default:
        for (final x in [0.31, 0.69]) {
          curve(p(x - 0.085, 0.46), p(x, 0.30), p(x + 0.085, 0.46));
        }
        curve(p(0.26, 0.58), p(0.5, 0.90), p(0.74, 0.58));
    }
  }

  @override
  bool shouldRepaint(_FacePainter old) =>
      old.level != level ||
      old.faceColor != faceColor ||
      old.featureColor != featureColor;
}
