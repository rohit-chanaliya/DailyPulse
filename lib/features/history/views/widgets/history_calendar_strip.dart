import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:dailypulse/core/constant/strings/history_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/theme/typography/app_typography.dart';
import 'package:dailypulse/core/utils/date_utils.dart' as app_date;
import 'package:dailypulse/core/widgets/buttons/app_button.dart';
import 'package:dailypulse/features/mood/models/mood_entry.dart';

/// Horizontal 30-day calendar strip with entry indicators and past-date backfill.
class HistoryCalendarStrip extends StatelessWidget {
  const HistoryCalendarStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.entries,
    required this.onBackfillPressed,
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;
  final List<MoodEntry> entries;
  final VoidCallback onBackfillPressed;

  static const int _daysCount = 30;

  Future<void> _pickArbitraryDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );
    if (picked != null) {
      onDateSelected(app_date.DateUtils.stripTime(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final now = DateTime.now();
    final today = app_date.DateUtils.stripTime(now);

    final days = [
      for (var i = _daysCount - 1; i >= 0; i--)
        today.subtract(Duration(days: i)),
    ];

    // Map day to moods logged on that date
    final moodsByDay = <DateTime, List<MoodEntry>>{};
    for (final entry in entries) {
      final day = app_date.DateUtils.stripTime(entry.timestamp);
      moodsByDay.putIfAbsent(day, () => <MoodEntry>[]).add(entry);
    }

    final hasSelectionNoEntries = selectedDate != null &&
        (moodsByDay[app_date.DateUtils.stripTime(selectedDate!)]?.isEmpty ??
            true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                HistoryStrings.calendar,
                style: context.textTheme.titleMedium?.copyWith(
                  color: home.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (selectedDate != null)
                TextButton(
                  onPressed: () => onDateSelected(null),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    HistoryStrings.allDays,
                    style: AppTypography.textXsBold.copyWith(
                      color: home.accent,
                    ),
                  ),
                ),
              IconButton(
                tooltip: HistoryStrings.pickDateTooltip,
                onPressed: () => _pickArbitraryDate(context),
                icon: Icon(
                  Icons.calendar_month_rounded,
                  size: 20,
                  color: home.textSecondary,
                ),
                style: IconButton.styleFrom(
                  fixedSize: const Size(36, 36),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: days.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = selectedDate != null &&
                  app_date.DateUtils.isSameDay(selectedDate!, day);
              final isToday = app_date.DateUtils.isSameDay(today, day);
              final dayEntries = moodsByDay[day];

              return _CalendarDayCell(
                date: day,
                isSelected: isSelected,
                isToday: isToday,
                entries: dayEntries ?? const [],
                onTap: () {
                  if (isSelected) {
                    onDateSelected(null);
                  } else {
                    onDateSelected(day);
                  }
                },
              );
            },
          ),
        ),
        if (hasSelectionNoEntries) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _BackfillPromptCard(
              date: selectedDate!,
              onBackfillPressed: onBackfillPressed,
            ),
          ),
        ],
      ],
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.entries,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final List<MoodEntry> entries;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final palette = context.logMood;

    final hasEntries = entries.isNotEmpty;
    final dotColor = hasEntries
        ? palette.faces[entries.last.moodLevel.clamp(0, palette.faces.length - 1)]
        : Colors.transparent;

    final bgColor = isSelected
        ? home.accent
        : (isToday ? home.searchSurface : home.surface);
    final textColor = isSelected
        ? home.onMedia
        : (isToday ? home.textPrimary : home.textSecondary);
    final dayLetterColor = isSelected ? home.onMedia : home.textMuted;

    return Semantics(
      button: true,
      selected: isSelected,
      label: DateFormat('EEEE, d MMMM').format(date),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? home.accent
                    : (isToday
                        ? home.accent.withValues(alpha: 0.5)
                        : home.textMuted.withValues(alpha: 0.15)),
                width: 1.2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('E').format(date).substring(0, 1),
                  style: AppTypography.textXsBold.copyWith(
                    color: dayLetterColor,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date.day.toString(),
                  style: context.textTheme.titleSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isSelected ? home.onMedia : dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackfillPromptCard extends StatelessWidget {
  const _BackfillPromptCard({
    required this.date,
    required this.onBackfillPressed,
  });

  final DateTime date;
  final VoidCallback onBackfillPressed;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final formattedDate = DateFormat('d MMMM y').format(date);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: home.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: home.accent.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: home.searchSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.edit_calendar_rounded,
              color: home.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  HistoryStrings.backfillTitle,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: home.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  formattedDate,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: home.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: HistoryStrings.backfillButton,
            size: AppButtonSize.xs,
            variant: AppButtonVariant.primary,
            onPressed: onBackfillPressed,
          ),
        ],
      ),
    );
  }
}
