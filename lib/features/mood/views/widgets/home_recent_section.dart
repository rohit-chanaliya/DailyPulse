import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/features/history/views/widgets/journal_empty_state.dart';
import 'package:dailypulse/features/history/views/widgets/journal_entry_card.dart';
import 'home_section_title.dart';

/// Latest mood entries, newest first, with a shortcut to History.
class HomeRecentSection extends StatelessWidget {
  const HomeRecentSection({super.key});

  static const _maxEntries = 5;

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final recent = [...appComponent.moodSignal.entries.value]
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
        final latest = recent.take(_maxEntries).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: HomeSectionTitle(
                HomeStrings.recentTitle,
                onSeeAll: latest.isEmpty
                    ? null
                    : () => context.go(AppRoutes.history),
              ),
            ),
            const SizedBox(height: 12),
            if (latest.isEmpty)
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
                  itemCount: latest.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => JournalEntryCard(entry: latest[i]),
                ),
              ),
          ],
        );
      },
    );
  }
}
