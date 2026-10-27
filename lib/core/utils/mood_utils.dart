import '../../core/constant/constants.dart';
import '../../features/mood/presentation/models/mood_option.dart';

class MoodUtils {
  /// Mood options in display order; `level` is the zero-based index used by
  /// the history and insights screens.
  static List<MoodOption> getMoodOptions() {
    return List.generate(
      AppConstants.moodLabels.length,
      (index) => MoodOption(
        label: AppConstants.moodLabels[index],
        emoji: AppConstants.moodEmojis[index],
        color: AppConstants.moodColorsDark[index],
        level: index,
      ),
    );
  }
}
