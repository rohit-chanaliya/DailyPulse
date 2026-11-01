import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:dailypulse/core/constant/strings/mood_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/mood/presentation/widgets/mood_face.dart';

/// "Mood Statistics": a pill bar with a face per day for the last 7 days.
class MoodWeekBars extends StatelessWidget {
  const MoodWeekBars({super.key, required this.averages, required this.today});

  /// Average level for each of the last 7 days, oldest first; `null` = none.
  final List<double?> averages;
  final DateTime today;

  static const double _maxBar = 230;
  static const double _minBar = 56;
  static const double _stub = 16;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final palette = context.logMood;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            MoodStrings.statistics,
            style: context.textTheme.headlineSmall?.copyWith(
              color: home.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: _maxBar + 8,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _GridPainter(
                    home.textMuted.withValues(alpha: 0.3),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i < averages.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      Expanded(
                        child: _Bar(
                          average: averages[i],
                          faceColor: averages[i] == null
                              ? null
                              : palette.faces[averages[i]!.round().clamp(0, 5)],
                          featureColor: averages[i] == null
                              ? null
                              : palette.backgrounds[averages[i]!
                                    .round()
                                    .clamp(0, 5)],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              for (var i = 0; i < averages.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    DateFormat.E().format(
                      today.subtract(Duration(days: averages.length - 1 - i)),
                    ),
                    textAlign: TextAlign.center,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: home.textMuted,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.average,
    required this.faceColor,
    required this.featureColor,
  });

  final double? average;
  final Color? faceColor;
  final Color? featureColor;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final avg = average;

    if (avg == null) {
      return Container(
        height: MoodWeekBars._stub,
        decoration: BoxDecoration(
          color: home.searchSurface.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    final height =
        MoodWeekBars._minBar +
        (avg / 5) * (MoodWeekBars._maxBar - MoodWeekBars._minBar);

    return Container(
      height: height,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: faceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: MoodFace(
        level: avg.round().clamp(0, 5),
        size: 28,
        glow: false,
        faceColor: featureColor!.withValues(alpha: 0.35),
        featureColor: featureColor!,
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (var l = 0; l <= 5; l++) {
      final y = size.height - 4 - l * (size.height - 8) / 5;
      for (var x = 0.0; x < size.width; x += 14) {
        canvas.drawLine(Offset(x, y), Offset(x + 7, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.color != color;
}
