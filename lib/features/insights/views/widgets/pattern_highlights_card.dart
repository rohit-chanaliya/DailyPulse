import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/insights_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/theme/typography/app_typography.dart';
import 'package:dailypulse/core/utils/advanced_insights_utils.dart';
import 'package:dailypulse/core/utils/mood_utils.dart';

/// Card showing weekly day patterns and time-of-day mood trends.
class PatternHighlightsCard extends StatelessWidget {
  const PatternHighlightsCard({
    super.key,
    required this.dayPattern,
    required this.timeSlots,
  });

  final DayPatternInsight dayPattern;
  final List<TimeSlotInsight> timeSlots;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    final hasDayData = dayPattern.bestDayName != null;
    final hasTimeData = timeSlots.isNotEmpty;

    if (!hasDayData && !hasTimeData) {
      return const SizedBox.shrink();
    }

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
            InsightsStrings.weeklyPatternsTitle,
            style: context.textTheme.headlineMedium?.copyWith(
              color: home.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (hasDayData) ...[
            Row(
              children: [
                Expanded(
                  child: _PatternPill(
                    title: InsightsStrings.bestDay,
                    day: dayPattern.bestDayName!,
                    averageMood: dayPattern.bestDayAverage!,
                    icon: Icons.wb_sunny_rounded,
                    isPositive: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PatternPill(
                    title: InsightsStrings.toughestDay,
                    day: dayPattern.worstDayName!,
                    averageMood: dayPattern.worstDayAverage!,
                    icon: Icons.cloud_outlined,
                    isPositive: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          if (hasTimeData) ...[
            Text(
              InsightsStrings.timeOfDayTitle,
              style: context.textTheme.titleSmall?.copyWith(
                color: home.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            for (final slot in timeSlots)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _TimeSlotRow(slot: slot),
              ),
          ],
        ],
      ),
    );
  }
}

class _PatternPill extends StatelessWidget {
  const _PatternPill({
    required this.title,
    required this.day,
    required this.averageMood,
    required this.icon,
    required this.isPositive,
  });

  final String title;
  final String day;
  final double averageMood;
  final IconData icon;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final palette = context.logMood;
    final moodIndex = averageMood.round().clamp(0, 5);
    final accentColor = isPositive ? palette.faces[4] : palette.faces[1];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: home.searchSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.25),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: accentColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: home.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            day,
            style: context.textTheme.titleSmall?.copyWith(
              color: home.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            MoodUtils.getMoodOptions()[moodIndex].label,
            style: AppTypography.textXsBold.copyWith(
              color: palette.faces[moodIndex],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeSlotRow extends StatelessWidget {
  const _TimeSlotRow({required this.slot});

  final TimeSlotInsight slot;

  static String _labelForSlot(TimeOfDaySlot s) => switch (s) {
        TimeOfDaySlot.morning => InsightsStrings.morning,
        TimeOfDaySlot.afternoon => InsightsStrings.afternoon,
        TimeOfDaySlot.evening => InsightsStrings.evening,
        TimeOfDaySlot.night => InsightsStrings.night,
      };

  static IconData _iconForSlot(TimeOfDaySlot s) => switch (s) {
        TimeOfDaySlot.morning => Icons.wb_twilight_rounded,
        TimeOfDaySlot.afternoon => Icons.wb_sunny_rounded,
        TimeOfDaySlot.evening => Icons.nights_stay_rounded,
        TimeOfDaySlot.night => Icons.bedtime_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final palette = context.logMood;
    final moodIndex = slot.averageMood.round().clamp(0, 5);

    return Row(
      children: [
        Icon(
          _iconForSlot(slot.slot),
          size: 16,
          color: home.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _labelForSlot(slot.slot),
            style: context.textTheme.bodySmall?.copyWith(
              color: home.textSecondary,
            ),
          ),
        ),
        Text(
          '${slot.count} logs',
          style: context.textTheme.bodySmall?.copyWith(
            color: home.textMuted,
            fontSize: 11,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: palette.faces[moodIndex],
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
