import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/mood/presentation/models/home_assets.dart';
import 'home_section_title.dart';
import 'mindful_tracker_card.dart';
import 'tracker_visualizations.dart';

class HomeTrackerSection extends StatelessWidget {
  const HomeTrackerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    return Column(
      children: [
        const HomeSectionTitle(
          HomeStrings.trackerTitle,
          actionIcon: HomeSectionTitle.metricsMenu,
        ),
        const SizedBox(height: 12),
        MindfulTrackerCard(
          icon: HomeAssets.clock,
          iconBackground: home.greenDark,
          title: HomeStrings.mindfulHours,
          content: const TrackerSubtitle(HomeStrings.mindfulHoursValue),
          trailing: SvgPicture.asset(
            HomeAssets.mindfulHoursChart,
            width: 64,
            height: 64,
          ),
        ),
        const SizedBox(height: 8),
        MindfulTrackerCard(
          icon: HomeAssets.hospitalBed,
          iconBackground: home.purpleDark,
          title: HomeStrings.sleepQuality,
          content: const TrackerSubtitle(HomeStrings.sleepValue),
          trailing: const SleepScore(),
        ),
        const SizedBox(height: 8),
        MindfulTrackerCard(
          icon: HomeAssets.documentHealthSolid,
          iconBackground: home.orangeDark,
          title: HomeStrings.mindfulJournal,
          content: const TrackerSubtitle(HomeStrings.journalStreak),
          trailing: const JournalHeatmap(),
        ),
        const SizedBox(height: 8),
        MindfulTrackerCard(
          icon: HomeAssets.headHeart,
          iconBackground: home.yellowDark,
          title: HomeStrings.stressLevel,
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StressBars(),
              SizedBox(height: 8),
              TrackerSubtitle(HomeStrings.stressValue),
            ],
          ),
        ),
        const SizedBox(height: 8),
        MindfulTrackerCard(
          icon: HomeAssets.trackerMoodHappy,
          iconBackground: home.headerSurface,
          title: HomeStrings.moodTracker,
          content: const MoodProgression(),
        ),
      ],
    );
  }
}
