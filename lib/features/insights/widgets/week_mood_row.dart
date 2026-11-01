import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/insights_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/mood/presentation/widgets/mood_face.dart';

/// "This Week": one mood face per weekday, from the logged entries.
class WeekMoodRow extends StatelessWidget {
  const WeekMoodRow({super.key, required this.averages});

  /// Average level per weekday (Mon..Sun); `null` when nothing was logged.
  final List<double?> averages;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final palette = context.logMood;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: home.surface,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            InsightsStrings.thisWeek,
            style: context.textTheme.headlineMedium?.copyWith(
              color: home.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (var i = 0; i < 7; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(
                  child: _DayPill(
                    label: InsightsStrings.weekdays[i],
                    level: averages[i]?.round().clamp(0, 5),
                    faceColor: averages[i] == null
                        ? null
                        : palette.faces[averages[i]!.round().clamp(0, 5)],
                    featureColor: averages[i] == null
                        ? null
                        : palette.backgrounds[averages[i]!.round().clamp(0, 5)],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill({
    required this.label,
    required this.level,
    required this.faceColor,
    required this.featureColor,
  });

  final String label;
  final int? level;
  final Color? faceColor;
  final Color? featureColor;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: home.searchSurface.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          if (level == null)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: home.textMuted.withValues(alpha: 0.25),
              ),
            )
          else
            MoodFace(
              level: level!,
              size: 32,
              glow: false,
              faceColor: faceColor!,
              featureColor: featureColor!,
            ),
          const SizedBox(height: 8),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: home.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
