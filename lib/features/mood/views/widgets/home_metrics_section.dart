import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'freud_score_card.dart';
import 'home_pager_dots.dart';
import 'home_section_title.dart';
import 'journal_metric_card.dart';
import 'mood_metric_card.dart';

class HomeMetricsSection extends StatelessWidget {
  const HomeMetricsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: HomeSectionTitle(
            HomeStrings.metricsTitle,
            actionIcon: HomeSectionTitle.metricsMenu,
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                FreudScoreCard(),
                SizedBox(width: 8),
                MoodMetricCard(),
                SizedBox(width: 8),
                JournalMetricCard(),
              ],
            ),
          ),
        ),
        SizedBox(height: 24),
        HomePagerDots(),
      ],
    );
  }
}
