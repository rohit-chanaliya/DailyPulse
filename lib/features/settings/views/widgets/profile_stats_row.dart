import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/profile_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';

/// Three divided stats: age, total entries and current streak.
class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({
    super.key,
    required this.age,
    required this.entries,
    required this.streak,
  });

  final int? age;
  final int entries;
  final int streak;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _Stat(
            label: ProfileStrings.statAge,
            value: age == null
                ? ProfileStrings.noValue
                : '$age${ProfileStrings.ageUnit}',
            showDivider: true,
          ),
          _Stat(
            label: ProfileStrings.statEntries,
            value: '$entries',
            showDivider: true,
          ),
          _Stat(
            label: ProfileStrings.statStreak,
            value: '$streak${ProfileStrings.streakUnit}',
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    this.showDivider = false,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(right: BorderSide(color: home.textMuted))
              : null,
        ),
        child: Column(
          spacing: 8,
          children: [
            Text(
              label,
              style: context.textTheme.titleLarge?.copyWith(
                color: home.textSecondary,
              ),
            ),
            Text(
              value,
              style: context.textTheme.headlineLarge?.copyWith(
                color: home.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
