import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/mood/presentation/models/home_assets.dart';
import 'home_asset_icon.dart';

class TrackerSubtitle extends StatelessWidget {
  const TrackerSubtitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.home.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class SleepScore extends StatelessWidget {
  const SleepScore({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(HomeAssets.sleepRing, width: 56, height: 56),
          Positioned(
            top: 4,
            right: 12,
            child: SvgPicture.asset(
              HomeAssets.sleepProgress,
              width: 32,
              height: 27,
            ),
          ),
          Text(
            HomeStrings.sleepScore,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.home.onMedia,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class JournalHeatmap extends StatelessWidget {
  const JournalHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    return SizedBox(
      width: 64,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: List.generate(16, (index) {
          final color = switch (index) {
            2 || 3 || 10 || 11 => home.orange,
            5 || 6 || 7 || 8 || 9 => index < 8 ? home.orange : home.orangeDark,
            _ => home.orangeDark,
          };
          return Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}

class StressBars extends StatelessWidget {
  const StressBars({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    return Row(
      children: List.generate(5, (index) {
        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(right: index == 4 ? 0 : 4),
            decoration: BoxDecoration(
              color: index < 3 ? home.yellow : home.headerSurface,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }),
    );
  }
}

class MoodProgression extends StatelessWidget {
  const MoodProgression({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    return FittedBox(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          _MoodTag(
            label: HomeStrings.sad,
            background: home.orangeDark,
            foreground: home.orange,
          ),
          const HomeAssetIcon(HomeAssets.arrowRight),
          _MoodTag(
            label: HomeStrings.neutral,
            background: home.headerSurface,
            foreground: home.accent,
          ),
          const HomeAssetIcon(HomeAssets.arrowRight),
          _MoodTag(
            label: HomeStrings.happy,
            background: home.greenDark,
            foreground: home.green,
          ),
        ],
      ),
    );
  }
}

class _MoodTag extends StatelessWidget {
  const _MoodTag({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label.toUpperCase(),
        style: context.textTheme.labelSmall?.copyWith(
          color: foreground,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
