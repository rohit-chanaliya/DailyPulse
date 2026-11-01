import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/history_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/history/widgets/journal_entry_card.dart';

/// Shown in place of the entry cards when nothing has been logged yet.
class JournalEmptyState extends StatelessWidget {
  const JournalEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Container(
      height: JournalEntryCard.height,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: home.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit_note_rounded, size: 48, color: home.accent),
          const SizedBox(height: 12),
          Text(
            HistoryStrings.emptyTitle,
            style: context.textTheme.headlineSmall?.copyWith(
              color: home.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            HistoryStrings.emptySubtitle,
            style: context.textTheme.bodySmall?.copyWith(
              color: home.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
