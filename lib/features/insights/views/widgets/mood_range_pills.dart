import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/insights_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/mood_series_utils.dart';

/// Segmented pill choosing how the mood chart is grouped.
class MoodRangePills extends StatelessWidget {
  const MoodRangePills({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final MoodGranularity selected;
  final ValueChanged<MoodGranularity> onChanged;

  static const _labels = {
    MoodGranularity.all: InsightsStrings.rangeAll,
    MoodGranularity.days: InsightsStrings.rangeDays,
    MoodGranularity.weeks: InsightsStrings.rangeWeeks,
    MoodGranularity.months: InsightsStrings.rangeMonths,
    MoodGranularity.years: InsightsStrings.rangeYears,
  };

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Container(
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: home.accent),
      ),
      child: Row(
        children: [
          for (final g in MoodGranularity.values)
            Expanded(
              child: Semantics(
                button: true,
                selected: g == selected,
                label: _labels[g],
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(g),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: g == selected ? home.accent : Colors.transparent,
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: Text(
                      _labels[g]!,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: g == selected
                            ? home.onMedia
                            : home.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
