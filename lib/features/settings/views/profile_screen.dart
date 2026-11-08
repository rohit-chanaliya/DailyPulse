import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/mood_stats_utils.dart';
import 'package:dailypulse/features/mood/views/widgets/freud_score_card.dart';
import 'package:dailypulse/features/mood/views/widgets/journal_metric_card.dart';
import 'package:dailypulse/features/mood/views/widgets/mood_metric_card.dart';
import 'package:dailypulse/features/settings/views/widgets/profile_hero_header.dart';
import 'package:dailypulse/features/settings/views/widgets/profile_stats_row.dart';

/// Profile overview: identity, quick stats and mood metric cards.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.home.background,
      body: SignalBuilder(
        builder: (context) {
          final auth = appComponent.authSignal;
          final user = auth.user.value;
          final profile = auth.profile.value;
          final entries = appComponent.moodSignal.entries.value;
          final now = DateTime.now();
          final name = profile?.fullName.isNotEmpty == true
              ? profile!.fullName
              : user?.displayName;

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: 24 + MediaQuery.paddingOf(context).bottom,
            ),
            child: Column(
              spacing: 24,
              children: [
                ProfileHeroHeader(
                  name: name,
                  memberSince: user?.metadata.creationTime,
                  imagePath: auth.profileImagePath.value,
                  avatarId: profile?.avatarId,
                  photoUrl: user?.photoURL,
                  onEdit: () => context.push(AppRoutes.profileEdit),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ProfileStatsRow(
                    age: profile?.ageAt(now),
                    entries: entries.length,
                    streak: MoodStatsUtils.currentStreak(entries, now: now),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      FreudScoreCard(
                        score: MoodStatsUtils.moodScore(entries, now: now),
                      ),
                      const SizedBox(width: 8),
                      MoodMetricCard(
                        recentLevels: MoodStatsUtils.recentLevels(entries, 12),
                      ),
                      const SizedBox(width: 8),
                      JournalMetricCard(
                        daysLogged: MoodStatsUtils.daysLoggedInYear(
                          entries,
                          now.year,
                        ),
                        daysInYear: MoodStatsUtils.daysInYear(now.year),
                        loggedDays: MoodStatsUtils.loggedDays(entries),
                        today: now,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
