import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/mood_utils.dart';
import 'package:dailypulse/core/utils/snackbar_utils.dart';
import 'package:dailypulse/features/mood/presentation/models/mood_option.dart';

/// Compact mood picker that starts the log-mood flow.
class HomeMoodPicker extends StatelessWidget {
  const HomeMoodPicker({super.key});

  void _onMoodSelected(BuildContext context, MoodOption mood) {
    final userId = appComponent.authSignal.user.value?.uid;
    if (userId == null) {
      SnackBarUtils.showError(context, HomeStrings.signInToLogMood);
      return;
    }

    context.push(AppRoutes.addNote, extra: mood);
  }

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final moods = MoodUtils.getMoodOptions();
    final moodColors = context.mood.values;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: home.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            HomeStrings.moodPickerTitle,
            style: context.textTheme.titleMedium?.copyWith(
              color: home.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            HomeStrings.moodPickerSubtitle,
            style: context.textTheme.bodySmall?.copyWith(color: home.textMuted),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: moods.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.55,
            ),
            itemBuilder: (context, index) {
              final mood = moods[index];
              return _MoodButton(
                mood: mood,
                color: moodColors[index],
                onTap: () => _onMoodSelected(context, mood),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MoodButton extends StatelessWidget {
  const _MoodButton({
    required this.mood,
    required this.color,
    required this.onTap,
  });

  final MoodOption mood;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mood.emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 4),
            Text(
              mood.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelMedium?.copyWith(
                color: context.home.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
