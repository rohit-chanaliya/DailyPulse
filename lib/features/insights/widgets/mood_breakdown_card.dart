import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/insights_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/analytics_utils.dart';
import 'package:dailypulse/core/utils/mood_utils.dart';
import 'package:dailypulse/features/mood/data/models/mood_entry.dart';
import 'package:dailypulse/features/mood/presentation/widgets/mood_face.dart';

/// Share of entries per mood, as labelled progress bars.
class MoodBreakdownCard extends StatelessWidget {
  const MoodBreakdownCard({super.key, required this.entries});

  final List<MoodEntry> entries;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final palette = context.logMood;
    final moods = MoodUtils.getMoodOptions();
    final counts =
        AnalyticsUtils.calculateAnalytics(entries)['moodCounts']
            as Map<int, int>? ??
        const {};
    final total = entries.length;

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
            InsightsStrings.breakdown,
            style: context.textTheme.headlineMedium?.copyWith(
              color: home.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < moods.length; i++)
            if ((counts[i] ?? 0) > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _BreakdownRow(
                  label: moods[i].label,
                  level: i,
                  fraction: counts[i]! / total,
                  faceColor: palette.faces[i],
                  featureColor: palette.backgrounds[i],
                  trackColor: home.searchSurface.withValues(alpha: 0.35),
                ),
              ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.level,
    required this.fraction,
    required this.faceColor,
    required this.featureColor,
    required this.trackColor,
  });

  final String label;
  final int level;
  final double fraction;
  final Color faceColor;
  final Color featureColor;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Column(
      children: [
        Row(
          children: [
            MoodFace(
              level: level,
              size: 28,
              glow: false,
              faceColor: faceColor,
              featureColor: featureColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: context.textTheme.titleMedium?.copyWith(
                  color: home.textPrimary,
                ),
              ),
            ),
            Text(
              '${(fraction * 100).round()}%',
              style: context.textTheme.labelLarge?.copyWith(color: faceColor),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 8,
            color: faceColor,
            backgroundColor: trackColor,
          ),
        ),
      ],
    );
  }
}
