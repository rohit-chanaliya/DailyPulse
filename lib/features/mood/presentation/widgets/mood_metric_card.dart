import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/mood/presentation/models/home_assets.dart';
import 'home_asset_icon.dart';
import 'home_metric_card.dart';

class MoodMetricCard extends StatelessWidget {
  const MoodMetricCard({super.key});

  static const _barHeights = [
    8.0,
    16.0,
    36.0,
    29.0,
    52.0,
    91.0,
    64.0,
    41.0,
    31.0,
    8.0,
    8.0,
    8.0,
  ];

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    return HomeMetricCard(
      color: home.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const HomeAssetIcon(HomeAssets.moodSad),
              const SizedBox(width: 8),
              Text(
                HomeStrings.mood,
                style: context.textTheme.titleMedium?.copyWith(
                  color: home.onMedia,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            HomeStrings.moodValue,
            style: context.textTheme.headlineLarge?.copyWith(
              color: home.orangePale,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 101,
            width: 131,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final (index, height) in _barHeights.indexed)
                  Container(
                    width: 8,
                    height: height,
                    margin: EdgeInsets.only(
                      right: index == _barHeights.length - 1 ? 0 : 3,
                    ),
                    decoration: BoxDecoration(
                      color: index >= 3 && index <= 7
                          ? home.orangePale
                          : home.orangeLight,
                      borderRadius: BorderRadius.circular(20),
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
