import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/strings/insights_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/utils/mood_series_utils.dart';
import 'package:dailypulse/core/widgets/screen_header.dart';
import 'package:dailypulse/features/insights/widgets/mood_breakdown_card.dart';
import 'package:dailypulse/features/insights/widgets/mood_curve_chart.dart';
import 'package:dailypulse/features/insights/widgets/mood_range_pills.dart';
import 'package:dailypulse/features/insights/widgets/week_mood_row.dart';
import 'package:dailypulse/core/widgets/empty_state.dart';

/// Mood over time: a grouped curve, this week's faces and the mood breakdown.
class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  MoodGranularity _granularity = MoodGranularity.all;

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
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SignalBuilder(
        builder: (context) {
          final entries = appComponent.insightsSignal.getAllEntries();
          final points = MoodSeriesUtils.series(entries, _granularity);
          final week = MoodSeriesUtils.weekAverages(entries, DateTime.now());

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
                    title: InsightsStrings.title,
                    subtitle: InsightsStrings.subtitle,
                    actionIcon: Icons.refresh_rounded,
                    actionTooltip: InsightsStrings.refreshTooltip,
                    onActionPressed: _refresh,
                    actionLoading: appComponent.moodSignal.isLoading.value,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MoodRangePills(
                    selected: _granularity,
                    onChanged: (g) => setState(() => _granularity = g),
                  ),
                ),
                const SizedBox(height: 16),
                if (entries.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: EmptyState(message: InsightsStrings.emptyMessage),
                  )
                else ...[
                  MoodCurveChart(points: points),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: WeekMoodRow(averages: week),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: MoodBreakdownCard(entries: entries),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
