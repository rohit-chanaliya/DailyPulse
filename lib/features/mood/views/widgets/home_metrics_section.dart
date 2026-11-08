import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/utils/mood_stats_utils.dart';
import 'freud_score_card.dart';
import 'home_pager_dots.dart';
import 'home_section_title.dart';
import 'journal_metric_card.dart';
import 'mood_metric_card.dart';

/// Score, latest mood and journal cards computed from the user's entries.
class HomeMetricsSection extends StatefulWidget {
  const HomeMetricsSection({super.key});

  @override
  State<HomeMetricsSection> createState() => _HomeMetricsSectionState();
}

class _HomeMetricsSectionState extends State<HomeMetricsSection> {
  static const _cardCount = 3;

  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _pageIndex {
    if (!_controller.hasClients ||
        !_controller.position.hasContentDimensions) {
      return 0;
    }
    final max = _controller.position.maxScrollExtent;
    if (max <= 0) return 0;
    final progress = (_controller.offset / max).clamp(0.0, 1.0);
    return (progress * (_cardCount - 1)).round();
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final entries = appComponent.moodSignal.entries.value;
        final now = DateTime.now();

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: HomeSectionTitle(
                HomeStrings.metricsTitle,
                actionIcon: HomeSectionTitle.metricsMenu,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  FreudScoreCard(
                    score: MoodStatsUtils.moodScore(entries, now: now),
                  ),
                  const SizedBox(width: 8),
                  MoodMetricCard(
                    recentLevels: MoodStatsUtils.recentLevels(entries, 12),
                    onTap: () => context.push(AppRoutes.mood),
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
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) =>
                  HomePagerDots(count: _cardCount, index: _pageIndex),
            ),
          ],
        );
      },
    );
  }
}
