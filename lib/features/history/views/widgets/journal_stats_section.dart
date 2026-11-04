import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dailypulse/core/constant/strings/history_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/mood_stats_utils.dart';
import 'package:dailypulse/core/utils/mood_utils.dart';
import 'package:dailypulse/features/app/presentation/models/nav_assets.dart';
import 'package:dailypulse/features/history/views/widgets/journal_stat_card.dart';
import 'package:dailypulse/features/mood/models/mood_entry.dart';

/// "Journal Stats": days logged this year and the most common mood.
class JournalStatsSection extends StatelessWidget {
  const JournalStatsSection({super.key, required this.entries});

  final List<MoodEntry> entries;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final year = DateTime.now().year;
    final logged = MoodStatsUtils.daysLoggedInYear(entries, year);
    final dominant = MoodStatsUtils.dominantLevel(entries);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          HistoryStrings.journalStats,
          style: context.textTheme.headlineSmall?.copyWith(
            color: home.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: JournalStatCard(
                icon: const Icon(Icons.description_outlined),
                iconBackground: home.greenDark,
                iconColor: home.green,
                value: '$logged/${MoodStatsUtils.daysInYear(year)}',
                caption: HistoryStrings.completed,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: JournalStatCard(
                icon: SvgPicture.asset(
                  NavAssets.insights,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    home.accent,
                    BlendMode.srcIn,
                  ),
                ),
                iconBackground: home.headerSurface,
                iconColor: home.accent,
                value: dominant == null
                    ? HistoryStrings.noEmotion
                    : MoodUtils.getMoodOptions()[dominant].label,
                caption: HistoryStrings.topEmotion,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
