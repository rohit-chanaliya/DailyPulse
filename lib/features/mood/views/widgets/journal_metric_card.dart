import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/mood/models/home_assets.dart';
import 'home_asset_icon.dart';
import 'home_metric_card.dart';

/// Days logged this year and a heatmap of the last 28 days.
class JournalMetricCard extends StatelessWidget {
  const JournalMetricCard({
    super.key,
    required this.daysLogged,
    required this.daysInYear,
    required this.loggedDays,
    required this.today,
  });

  final int daysLogged;
  final int daysInYear;
  final Set<DateTime> loggedDays;
  final DateTime today;

  static const _cells = 28;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return HomeMetricCard(
      color: home.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              const HomeAssetIcon(HomeAssets.documentHealth),
              Expanded(
                child: Text(
                  HomeStrings.healthJournal,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: home.onMedia,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$daysLogged/$daysInYear',
            maxLines: 1,
            style: context.textTheme.headlineLarge?.copyWith(
              color: home.purplePale,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 116,
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (var i = _cells - 1; i >= 0; i--)
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color:
                          loggedDays.contains(
                            DateTime(today.year, today.month, today.day - i),
                          )
                          ? home.onMedia
                          : home.purpleLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
