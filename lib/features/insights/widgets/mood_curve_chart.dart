import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/mood_series_utils.dart';
import 'package:dailypulse/core/utils/mood_utils.dart';

/// Smooth stepped mood curve with dashed grid lines and labelled markers.
class MoodCurveChart extends StatelessWidget {
  const MoodCurveChart({super.key, required this.points});

  final List<MoodPoint> points;

  static const double height = 280;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final palette = context.logMood;
    final labels = [for (final m in MoodUtils.getMoodOptions()) m.label];

    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _ChartPainter(
          points: points,
          labels: labels,
          markerColors: palette.faces,
          markerTextColors: palette.backgrounds,
          lineColor: home.accent,
          fillColor: home.headerSurface,
          gridColor: home.textMuted.withValues(alpha: 0.3),
          ringColor: home.background,
          dotColor: home.onMedia,
          labelStyle:
              context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ) ??
              const TextStyle(),
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({
    required this.points,
    required this.labels,
    required this.markerColors,
    required this.markerTextColors,
    required this.lineColor,
    required this.fillColor,
    required this.gridColor,
    required this.ringColor,
    required this.dotColor,
    required this.labelStyle,
  });

  final List<MoodPoint> points;
  final List<String> labels;
  final List<Color> markerColors;
  final List<Color> markerTextColors;
  final Color lineColor;
  final Color fillColor;
  final Color gridColor;
  final Color ringColor;
  final Color dotColor;
  final TextStyle labelStyle;

  static const double _top = 64;
  static const double _bottom = 28;
  static const double _edge = 28;
  static const int _maxLevel = 5;

  double _y(double level, Size size) =>
      _top + (1 - level / _maxLevel) * (size.height - _top - _bottom);

  List<Offset> _positions(Size size) {
    if (points.length == 1) return [Offset(size.width / 2, _y(points[0].level, size))];
    final span = size.width - _edge * 2;
    return [
      for (var i = 0; i < points.length; i++)
        Offset(_edge + span * i / (points.length - 1), _y(points[i].level, size)),
    ];
  }

  void _grid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    const dash = 8.0;
    const gap = 8.0;
    for (var l = 0; l <= _maxLevel; l++) {
      final y = _y(l.toDouble(), size);
      for (var x = 0.0; x < size.width; x += dash + gap) {
        canvas.drawLine(Offset(x, y), Offset(x + dash, y), paint);
      }
    }
  }

  Path _curve(List<Offset> pos, Size size) {
    final path = Path()..moveTo(0, pos.first.dy);
    path.lineTo(pos.first.dx, pos.first.dy);
    for (var i = 1; i < pos.length; i++) {
      final a = pos[i - 1];
      final b = pos[i];
      final mid = (a.dx + b.dx) / 2;
      path.cubicTo(mid, a.dy, mid, b.dy, b.dx, b.dy);
    }
    path.lineTo(size.width, pos.last.dy);
    return path;
  }

  Set<int> _markerIndexes(List<Offset> pos) {
    var maxI = 0;
    var minI = 0;
    for (var i = 1; i < points.length; i++) {
      if (points[i].level > points[maxI].level) maxI = i;
      if (points[i].level < points[minI].level) minI = i;
    }
    final chosen = <int>[];
    for (final i in [maxI, minI, points.length - 1]) {
      if (chosen.every((c) => (pos[c].dx - pos[i].dx).abs() > 72)) {
        chosen.add(i);
      }
    }
    return chosen.toSet();
  }

  void _marker(Canvas canvas, Size size, Offset p, MoodPoint point) {
    final level = point.level.round().clamp(0, _maxLevel);
    final color = markerColors[level];

    canvas.drawCircle(p, 13, Paint()..color = ringColor);
    canvas.drawCircle(p, 8, Paint()..color = color);
    canvas.drawCircle(p, 2.5, Paint()..color = dotColor);

    final tp = TextPainter(
      text: TextSpan(
        text: labels[level],
        style: labelStyle.copyWith(color: markerTextColors[level]),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final w = tp.width + 28;
    final h = tp.height + 14;
    final left = (p.dx - w / 2).clamp(4.0, size.width - w - 4);
    final rect = Rect.fromLTWH(left, p.dy - 22 - h, w, h);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(h / 2)),
      Paint()..color = color,
    );
    canvas.drawPath(
      Path()
        ..moveTo(p.dx - 6, rect.bottom - 1)
        ..lineTo(p.dx + 6, rect.bottom - 1)
        ..lineTo(p.dx, rect.bottom + 7)
        ..close(),
      Paint()..color = color,
    );
    tp.paint(canvas, Offset(rect.left + 14, rect.top + 7));
  }

  @override
  void paint(Canvas canvas, Size size) {
    _grid(canvas, size);
    if (points.isEmpty) return;

    final pos = _positions(size);
    final line = _curve(pos, size);

    final fill = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [fillColor, fillColor.withValues(alpha: 0)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      line,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = lineColor,
    );

    for (final i in _markerIndexes(pos)) {
      _marker(canvas, size, pos[i], points[i]);
    }
  }

  @override
  bool shouldRepaint(_ChartPainter old) =>
      old.points != points ||
      old.lineColor != lineColor ||
      old.fillColor != fillColor ||
      old.gridColor != gridColor;
}
