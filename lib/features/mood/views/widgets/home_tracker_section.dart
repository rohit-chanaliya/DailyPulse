import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/mood_stats_utils.dart';
import 'package:dailypulse/features/mood/models/home_assets.dart';
import 'home_section_title.dart';
import 'mindful_tracker_card.dart';
import 'tracker_visualizations.dart';

/// Journal streak, stress and mood trend derived from the user's entries.
class HomeTrackerSection extends StatelessWidget {
  const HomeTrackerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return SignalBuilder(
      builder: (context) {
        final entries = appComponent.moodSignal.entries.value;
        final now = DateTime.now();
        final streak = MoodStatsUtils.currentStreak(entries, now: now);
        final stress = MoodStatsUtils.stressLevel(entries, now: now);
        final trend = MoodStatsUtils.recentLevels(entries, 3);

        return Column(
          children: [
            const HomeSectionTitle(
              HomeStrings.trackerTitle,
              actionIcon: HomeSectionTitle.metricsMenu,
            ),
            const SizedBox(height: 12),
            MindfulTrackerCard(
              icon: HomeAssets.documentHealthSolid,
              iconBackground: home.orangeDark,
              title: HomeStrings.mindfulJournal,
              content: TrackerSubtitle(
                entries.isEmpty
                    ? HomeStrings.journalEmpty
                    : '$streak ${HomeStrings.dayStreak}',
              ),
              trailing: JournalHeatmap(
                loggedDays: MoodStatsUtils.loggedDays(entries),
                today: now,
              ),
            ),
            const SizedBox(height: 8),
            MindfulTrackerCard(
              icon: HomeAssets.headHeart,
              iconBackground: home.yellowDark,
              title: HomeStrings.stressLevel,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StressBars(level: stress ?? 0),
                  const SizedBox(height: 8),
                  TrackerSubtitle(_stressLabel(stress)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            MindfulTrackerCard(
              icon: HomeAssets.trackerMoodHappy,
              iconBackground: home.headerSurface,
              title: HomeStrings.moodTracker,
              content: trend.isEmpty
                  ? const TrackerSubtitle(HomeStrings.moodTrackerEmpty)
                  : MoodProgression(levels: trend),
            ),
          ],
        );
      },
    );
  }

  static String _stressLabel(int? level) => switch (level) {
    null => HomeStrings.stressNoData,
    <= 2 => HomeStrings.stressLabel(level, HomeStrings.stressLow),
    3 => HomeStrings.stressLabel(level, HomeStrings.stressNormal),
    _ => HomeStrings.stressLabel(level, HomeStrings.stressHigh),
  };
}
