import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/mood/presentation/models/home_assets.dart';
import 'home_asset_icon.dart';
import 'home_metric_card.dart';

class FreudScoreCard extends StatelessWidget {
  const FreudScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    return HomeMetricCard(
      color: home.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const HomeAssetIcon(HomeAssets.heart),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  HomeStrings.freudScore,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: home.onMedia,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 131,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  HomeAssets.freudScoreRing,
                  width: 120,
                  height: 120,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      HomeStrings.score,
                      style: context.textTheme.headlineLarge?.copyWith(
                        color: home.greenPale,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      HomeStrings.scoreStatus,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: home.greenLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
