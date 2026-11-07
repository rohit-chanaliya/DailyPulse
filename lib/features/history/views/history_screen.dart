import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/strings/history_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/date_utils.dart' as app_date;
import 'package:dailypulse/core/widgets/screen_header.dart';
import 'package:dailypulse/features/history/views/widgets/history_calendar_strip.dart';
import 'package:dailypulse/features/history/views/widgets/journal_empty_state.dart';
import 'package:dailypulse/features/history/views/widgets/journal_entry_card.dart';
import 'package:dailypulse/features/history/views/widgets/journal_sort_pill.dart';
import 'package:dailypulse/features/history/views/widgets/journal_stats_section.dart';
import 'package:dailypulse/features/mood/views/log_mood_screen.dart';

/// Every logged entry as scrollable cards, calendar filter, and journal stats.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime? _selectedDate;

  Future<void> _refresh() async {
    final user = appComponent.authSignal.user.value;
    if (user != null) {
      await appComponent.moodSignal.fetchMoodEntries(user.uid);
    }
  }

  void _backfill(DateTime? date) {
    context.push(
      AppRoutes.logMood,
      extra: {
        'level': LogMoodScreen.defaultLevel,
        'timestamp': date ?? DateTime.now(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: SignalBuilder(
        builder: (context) {
          final entries = appComponent.moodSignal.entries.value;
          final ordered = appComponent.moodSignal.orderedEntries.value;

          final displayed = _selectedDate == null
              ? ordered
              : ordered
                  .where((e) =>
                      app_date.DateUtils.isSameDay(e.timestamp, _selectedDate!))
                  .toList();

          final titleText = _selectedDate == null
              ? HistoryStrings.allJournals
              : DateFormat('d MMMM y').format(_selectedDate!);

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: 24,
              bottom: 24 + MediaQuery.paddingOf(context).bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ScreenHeader(
                    title: HistoryStrings.title,
                    subtitle: HistoryStrings.subtitle,
                    actionIcon: Icons.refresh_rounded,
                    actionTooltip: HistoryStrings.refreshTooltip,
                    onActionPressed: _refresh,
                    actionLoading: appComponent.moodSignal.isLoading.value,
                  ),
                ),
                const SizedBox(height: 20),
                HistoryCalendarStrip(
                  selectedDate: _selectedDate,
                  onDateSelected: (d) => setState(() => _selectedDate = d),
                  entries: entries,
                  onBackfillPressed: () => _backfill(_selectedDate),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          titleText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.headlineSmall?.copyWith(
                            color: home.textPrimary,
                          ),
                        ),
                      ),
                      JournalSortPill(
                        newestFirst: appComponent.moodSignal.newestFirst.value,
                        onChanged: (v) =>
                            appComponent.moodSignal.newestFirst.value = v,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (displayed.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: JournalEmptyState(),
                  )
                else
                  SizedBox(
                    height: JournalEntryCard.height,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: displayed.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, i) =>
                          JournalEntryCard(entry: displayed[i]),
                    ),
                  ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: JournalStatsSection(entries: entries),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
