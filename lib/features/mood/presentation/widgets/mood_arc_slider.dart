import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/mood_utils.dart';

/// Smile-shaped dashed slider with one stop per mood level; drag or tap to choose.
class MoodArcSlider extends StatelessWidget {
  const MoodArcSlider({
    super.key,
    required this.level,
    required this.onChanged,
  });

  final int level;
  final ValueChanged<int> onChanged;

  static const double height = 92;
  static const double stopSize = 30;

  @override
  Widget build(BuildContext context) {
    final palette = context.logMood;
    final labels = [for (final m in MoodUtils.getMoodOptions()) m.label];
    final count = labels.length;

    return Semantics(
      slider: true,
      value: labels[level],
      increasedValue: labels[math.min(level + 1, count - 1)],
      decreasedValue: labels[math.max(level - 1, 0)],
      onIncrease: level < count - 1 ? () => onChanged(level + 1) : null,
      onDecrease: level > 0 ? () => onChanged(level - 1) : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (d) => _select(context, d.localPosition.dx, count),
        onHorizontalDragUpdate: (d) =>
            _select(context, d.localPosition.dx, count),
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: CustomPaint(
            painter: _ArcPainter(
              level: level,
              count: count,
              activeColor: palette.activeStop,
              inactiveColor: palette.inactive[level],
              dotColor: palette.backgrounds[level],
            ),
          ),
        ),
      ),
    );
  }

  void _select(BuildContext context, double dx, int count) {
    final width = context.size?.width ?? 0;
    if (width <= stopSize) return;
    final next = _nearestStop(dx, width, count);
    if (next != level) {
      HapticFeedback.selectionClick();
      onChanged(next);
    }
  }

  static int _nearestStop(double dx, double width, int count) {
    final usable = width - stopSize;
    final t = ((dx - stopSize / 2) / usable).clamp(0.0, 1.0);
    return (t * (count - 1)).round();
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({
    required this.level,
    required this.count,
    required this.activeColor,
    required this.inactiveColor,
    required this.dotColor,
  });

  final int level;
  final int count;
  final Color activeColor;
  final Color inactiveColor;
  final Color dotColor;

  static const int _dashSamples = 8;

  Offset _point(double t, double width) {
    const r = MoodArcSlider.stopSize / 2;
    const depth = MoodArcSlider.height - MoodArcSlider.stopSize;
    final x = r + t * (width - MoodArcSlider.stopSize);
    final y = r + depth * (1 - math.pow(2 * t - 1, 2));
    return Offset(x, y);
  }

  Path _dash(double from, double to, double width) {
    final path = Path();
    for (var i = 0; i <= _dashSamples; i++) {
      final p = _point(from + (to - from) * i / _dashSamples, width);
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final last = count - 1;
    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    for (var i = 0; i < last; i++) {
      final mid = (i + 0.5) / last;
      final half = 0.27 / last;
      dashPaint.color = i + 1 <= level ? activeColor : inactiveColor;
      canvas.drawPath(_dash(mid - half, mid + half, size.width), dashPaint);
    }

    for (var i = 0; i <= last; i++) {
      final center = _point(i / last, size.width);
      canvas.drawCircle(
        center,
        MoodArcSlider.stopSize / 2,
        Paint()..color = i <= level ? activeColor : inactiveColor,
      );
      canvas.drawCircle(center, 3.5, Paint()..color = dotColor);
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.level != level ||
      old.count != count ||
      old.activeColor != activeColor ||
      old.inactiveColor != inactiveColor ||
      old.dotColor != dotColor;
}
