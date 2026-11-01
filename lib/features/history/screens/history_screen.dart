import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/strings/history_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/widgets/screen_header.dart';
import 'package:dailypulse/features/history/widgets/journal_empty_state.dart';
import 'package:dailypulse/features/history/widgets/journal_entry_card.dart';
import 'package:dailypulse/features/history/widgets/journal_sort_pill.dart';
import 'package:dailypulse/features/history/widgets/journal_stats_section.dart';
import 'package:dailypulse/features/mood/data/models/mood_entry.dart';

/// Every logged entry as scrollable cards, plus a few journal stats.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _newestFirst = true;

  @override
  void initState() {
    super.initState();
    appComponent.moodSignal.reloadLocalEntries();
  }

  Future<void> _refresh() async {
    final user = appComponent.authSignal.user.value;
    if (user != null) {
      await appComponent.moodSignal.fetchMoodEntries(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: StreamBuilder<List<MoodEntry>>(
        stream: appComponent.moodSignal.watchLocalEntries(),
        initialData: appComponent.moodSignal.entries.value,
        builder: (context, snapshot) {
          final entries = snapshot.data ?? const <MoodEntry>[];
          final ordered = _newestFirst ? entries : entries.reversed.toList();

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
                  child: SignalBuilder(
                    builder: (context) => ScreenHeader(
                      title: HistoryStrings.title,
                      subtitle: HistoryStrings.subtitle,
                      actionIcon: Icons.refresh_rounded,
                      actionTooltip: HistoryStrings.refreshTooltip,
                      onActionPressed: _refresh,
                      actionLoading: appComponent.moodSignal.isLoading.value,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        HistoryStrings.allJournals,
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: home.textPrimary,
                        ),
                      ),
                      JournalSortPill(
                        newestFirst: _newestFirst,
                        onChanged: (v) => setState(() => _newestFirst = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (ordered.isEmpty)
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
                      itemCount: ordered.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, i) =>
                          JournalEntryCard(entry: ordered[i]),
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
