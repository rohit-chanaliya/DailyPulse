import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/insights_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/theme/typography/app_typography.dart';
import 'package:dailypulse/core/utils/advanced_insights_utils.dart';
import 'package:dailypulse/core/utils/mood_utils.dart';
import 'package:dailypulse/features/mood/views/widgets/journal_tag_picker.dart';

/// Card showing how activity tags correlate with mood levels.
class TagMoodCorrelationCard extends StatelessWidget {
  const TagMoodCorrelationCard({super.key, required this.stats});

  final List<TagMoodStat> stats;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

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
            InsightsStrings.tagCorrelationTitle,
            style: context.textTheme.headlineMedium?.copyWith(
              color: home.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            InsightsStrings.tagCorrelationSubtitle,
            style: context.textTheme.bodySmall?.copyWith(
              color: home.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          if (stats.isEmpty)
            _EmptyTagsPrompt()
          else
            for (final stat in stats)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _TagStatRow(stat: stat),
              ),
        ],
      ),
    );
  }
}

class _EmptyTagsPrompt extends StatelessWidget {
  const _EmptyTagsPrompt();

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: home.searchSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            Icons.sell_outlined,
            size: 24,
            color: home.accent,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              InsightsStrings.noTagsPrompt,
              style: context.textTheme.bodySmall?.copyWith(
                color: home.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagStatRow extends StatelessWidget {
  const _TagStatRow({required this.stat});

  final TagMoodStat stat;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final palette = context.logMood;
    final moodIndex = stat.averageMood.round().clamp(0, 5);
    final moodLabel = MoodUtils.getMoodOptions()[moodIndex].label;

    final isPositive = stat.moodDelta > 0.2;
    final isNegative = stat.moodDelta < -0.2;

    final badgeColor = isPositive
        ? context.status.success
        : (isNegative ? context.status.error : home.textMuted);

    final deltaText = isPositive
        ? '+${stat.moodDelta.toStringAsFixed(1)}'
        : (isNegative
            ? stat.moodDelta.toStringAsFixed(1)
            : '±0.0');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              JournalTagPicker.iconForTag(stat.tag),
              size: 16,
              color: home.accent,
            ),
            const SizedBox(width: 8),
            Text(
              stat.tag,
              style: context.textTheme.titleSmall?.copyWith(
                color: home.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '(${stat.count})',
              style: context.textTheme.bodySmall?.copyWith(
                color: home.textMuted,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositive
                        ? Icons.arrow_upward_rounded
                        : (isNegative
                            ? Icons.arrow_downward_rounded
                            : Icons.horizontal_rule_rounded),
                    size: 11,
                    color: badgeColor,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    deltaText,
                    style: AppTypography.textXsBold.copyWith(
                      color: badgeColor,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              moodLabel,
              style: context.textTheme.labelSmall?.copyWith(
                color: palette.faces[moodIndex],
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (stat.averageMood / 5.0).clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: home.searchSurface,
            valueColor: AlwaysStoppedAnimation<Color>(palette.faces[moodIndex]),
          ),
        ),
      ],
    );
  }
}
