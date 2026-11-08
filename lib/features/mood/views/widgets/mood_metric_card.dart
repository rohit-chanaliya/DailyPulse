import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/constants.dart';
import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'home_metric_card.dart';

/// Latest mood plus a bar per recent entry (taller = better mood).
class MoodMetricCard extends StatelessWidget {
  const MoodMetricCard({super.key, required this.recentLevels, this.onTap});

  /// Mood levels (0-5) of the most recent entries, oldest first.
  final List<int> recentLevels;
  final VoidCallback? onTap;

  static const _barCount = 12;
  static const _minBar = 8.0;
  static const _maxBar = 91.0;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final latest = recentLevels.isEmpty ? null : recentLevels.last;
    final padded = [
      ...List<int?>.filled(_barCount - recentLevels.length, null),
      ...recentLevels,
    ];

    return GestureDetector(
      onTap: onTap,
      child: HomeMetricCard(
        color: home.orange,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              children: [
                Text(
                  latest == null ? '' : AppConstants.moodEmojis[latest],
                  style: const TextStyle(fontSize: 22),
                ),
                Text(
                  HomeStrings.mood,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: home.onMedia,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              latest == null
                  ? HomeStrings.moodNotLogged
                  : AppConstants.moodLabels[latest],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.headlineLarge?.copyWith(
                color: home.orangePale,
              ),
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 3,
              children: [
                for (var i = 0; i < padded.length; i++)
                  Container(
                    width: 8,
                    height: switch (padded[i]) {
                      final int level =>
                        _minBar + level / 5 * (_maxBar - _minBar),
                      null => _minBar,
                    },
                    decoration: BoxDecoration(
                      color: padded[i] != null && i >= padded.length - 6
                          ? home.orangePale
                          : home.orangeLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
