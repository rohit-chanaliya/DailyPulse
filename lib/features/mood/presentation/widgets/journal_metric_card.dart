import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/mood/presentation/models/home_assets.dart';
import 'home_asset_icon.dart';
import 'home_metric_card.dart';

class JournalMetricCard extends StatelessWidget {
  const JournalMetricCard({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    return HomeMetricCard(
      color: home.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const HomeAssetIcon(HomeAssets.documentHealth),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  HomeStrings.healthJournal,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: home.onMedia,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            HomeStrings.journalProgress,
            style: context.textTheme.headlineLarge?.copyWith(
              color: home.purplePale,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 116,
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(28, (index) {
                final color = switch (index % 7) {
                  0 || 1 || 2 || 5 => home.purpleLight,
                  3 || 6 => home.purplePale,
                  _ => home.onMedia,
                };
                return Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
