import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/mood/presentation/models/home_assets.dart';
import 'home_asset_icon.dart';

class HomeSectionTitle extends StatelessWidget {
  const HomeSectionTitle(this.title, {super.key, this.actionIcon});

  final String title;
  final String? actionIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.home.textPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.18,
          ),
        ),
        if (actionIcon case final icon?)
          HomeAssetIcon(icon)
        else
          Text(
            HomeStrings.seeAll,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.home.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  static const metricsMenu = HomeAssets.moreVertical;
  static const chatbotSettings = HomeAssets.gear;
}
