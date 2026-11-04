import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:dailypulse/core/constant/strings/log_mood_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/date_utils.dart' as app_date;

/// Close button plus the optional back-date and journal actions.
class LogMoodTopBar extends StatelessWidget {
  const LogMoodTopBar({
    super.key,
    required this.timestamp,
    required this.onTimestampChanged,
    required this.onJournalTap,
  });

  final DateTime? timestamp;
  final ValueChanged<DateTime> onTimestampChanged;
  final VoidCallback onJournalTap;

  String _whenLabel(DateTime ts) {
    final time = DateFormat.jm().format(ts);
    final now = DateTime.now();
    if (app_date.DateUtils.isSameDay(ts, now)) {
      return '${LogMoodStrings.today}, $time';
    }
    if (app_date.DateUtils.isSameDay(
      ts,
      now.subtract(const Duration(days: 1)),
    )) {
      return '${LogMoodStrings.yesterday}, $time';
    }
    return '${DateFormat('d MMM y').format(ts)}, $time';
  }

  Future<void> _pickWhen(BuildContext context) async {
    final now = DateTime.now();
    final initial = timestamp ?? now;

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      helpText: LogMoodStrings.pickDateHelp,
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;

    final picked = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    onTimestampChanged(picked.isAfter(now) ? now : picked);
  }

  @override
  Widget build(BuildContext context) {
    final onMood = context.logMood.onMood;
    final ts = timestamp;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            tooltip: LogMoodStrings.closeLabel,
            onPressed: () => context.pop(),
            icon: Icon(Icons.close_rounded, color: onMood),
          ),
          const Spacer(),
          if (ts != null)
            Text(
              _whenLabel(ts),
              style: context.textTheme.labelLarge?.copyWith(color: onMood),
            ),
          IconButton(
            tooltip: LogMoodStrings.changeWhenTooltip,
            onPressed: () => _pickWhen(context),
            icon: Icon(
              ts == null
                  ? Icons.calendar_today_outlined
                  : Icons.calendar_today_rounded,
              color: onMood,
              size: 22,
            ),
          ),
          IconButton(
            tooltip: LogMoodStrings.journalTooltip,
            onPressed: onJournalTap,
            icon: Icon(Icons.edit_note_rounded, color: onMood),
          ),
        ],
      ),
    );
  }
}
