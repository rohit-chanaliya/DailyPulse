import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:dailypulse/core/constant/strings/history_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/date_utils.dart' as app_date;
import 'package:dailypulse/core/utils/mood_utils.dart';
import 'package:dailypulse/features/mood/models/mood_entry.dart';
import 'package:dailypulse/features/mood/views/widgets/mood_face.dart';

/// Card for one entry: mood icon, mood chip, title and an excerpt.
class JournalEntryCard extends StatelessWidget {
  const JournalEntryCard({super.key, required this.entry});

  final MoodEntry entry;

  static const double width = 220;
  static const double height = 250;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final palette = context.logMood;
    final level = entry.moodLevel.clamp(0, palette.faces.length - 1);
    final label = MoodUtils.getMoodOptions()[level].label;
    final title = entry.title?.trim();
    final note = entry.note?.trim();

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: home.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: palette.faces[level],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: MoodFace(
                  level: level,
                  size: 28,
                  glow: false,
                  faceColor: Colors.transparent,
                  featureColor: home.onMedia,
                ),
              ),
              const Spacer(),
              Text(
                DateFormat('d MMM').format(entry.timestamp),
                style: context.textTheme.labelMedium?.copyWith(
                  color: home.textMuted,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: palette.backgrounds[level],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${HistoryStrings.moodChipPrefix}${label.toUpperCase()}',
              style: context.textTheme.labelSmall?.copyWith(
                color: palette.faces[level],
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title == null || title.isEmpty ? label : title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.headlineMedium?.copyWith(
              color: home.textPrimary,
            ),
          ),
          if (entry.tags.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (final tag in entry.tags.take(3))
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: home.searchSurface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: context.textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        color: home.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (entry.tags.length > 3)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '+${entry.tags.length - 3}',
                      style: context.textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        color: home.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 4),
          Text(
            note == null || note.isEmpty
                ? app_date.DateUtils.formatTime(entry.timestamp)
                : note,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall?.copyWith(
              color: home.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
