import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/constants.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/mood/models/home_assets.dart';
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

/// 4x4 grid of the last 16 days; lit cells are days with an entry.
class JournalHeatmap extends StatelessWidget {
  const JournalHeatmap({
    super.key,
    required this.loggedDays,
    required this.today,
  });

  static const _cells = 16;

  final Set<DateTime> loggedDays;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return SizedBox(
      width: 64,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (var i = _cells - 1; i >= 0; i--)
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color:
                    loggedDays.contains(
                      DateTime(today.year, today.month, today.day - i),
                    )
                    ? home.orange
                    : home.orangeDark,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }
}

/// Five segments, the first [level] of them lit.
class StressBars extends StatelessWidget {
  const StressBars({super.key, required this.level});

  final int level;

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
              color: index < level ? home.yellow : home.headerSurface,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }),
    );
  }
}

/// The last few mood levels, oldest first, joined by arrows.
class MoodProgression extends StatelessWidget {
  const MoodProgression({super.key, required this.levels});

  final List<int> levels;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return FittedBox(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          for (var i = 0; i < levels.length; i++) ...[
            if (i > 0) const HomeAssetIcon(HomeAssets.arrowRight),
            _MoodTag(
              label: AppConstants.moodLabels[levels[i]],
              background: switch (levels[i]) {
                <= 1 => home.orangeDark,
                <= 3 => home.headerSurface,
                _ => home.greenDark,
              },
              foreground: switch (levels[i]) {
                <= 1 => home.orange,
                <= 3 => home.accent,
                _ => home.green,
              },
            ),
          ],
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
