import 'package:flutter_test/flutter_test.dart';

import 'package:dailypulse/core/utils/advanced_insights_utils.dart';
import 'package:dailypulse/features/mood/models/mood_entry.dart';

void main() {
  group('AdvancedInsightsUtils', () {
    test('computeTagStats returns empty list when no entries or tags exist', () {
      expect(AdvancedInsightsUtils.computeTagStats([]), isEmpty);

      final noTags = [
        MoodEntry(timestamp: DateTime.now(), moodLevel: 3),
      ];
      expect(AdvancedInsightsUtils.computeTagStats(noTags), isEmpty);
    });

    test('computeTagStats calculates correct average and delta', () {
      final entries = [
        MoodEntry(
          timestamp: DateTime.now(),
          moodLevel: 5,
          tags: const ['Exercise', 'Health'],
        ),
        MoodEntry(
          timestamp: DateTime.now(),
          moodLevel: 1,
          tags: const ['Work'],
        ),
      ];

      final stats = AdvancedInsightsUtils.computeTagStats(entries);
      expect(stats.length, 3);

      final exercise = stats.firstWhere((s) => s.tag == 'Exercise');
      expect(exercise.count, 1);
      expect(exercise.averageMood, 5.0);
      expect(exercise.moodDelta, 2.0); // 5.0 - 3.0 overall avg = 2.0

      final work = stats.firstWhere((s) => s.tag == 'Work');
      expect(work.averageMood, 1.0);
      expect(work.moodDelta, -2.0); // 1.0 - 3.0 overall avg = -2.0
    });

    test('computeDayPattern identifies best and worst day of week', () {
      final entries = [
        // Monday (weekday 1)
        MoodEntry(timestamp: DateTime(2026, 11, 2), moodLevel: 1),
        // Friday (weekday 5)
        MoodEntry(timestamp: DateTime(2026, 11, 6), moodLevel: 5),
      ];

      final pattern = AdvancedInsightsUtils.computeDayPattern(entries);
      expect(pattern.bestDayName, 'Friday');
      expect(pattern.bestDayAverage, 5.0);
      expect(pattern.worstDayName, 'Monday');
      expect(pattern.worstDayAverage, 1.0);
    });

    test('computeTimeSlots classifies hours into slots', () {
      final entries = [
        MoodEntry(timestamp: DateTime(2026, 1, 1, 8, 30), moodLevel: 4), // Morning
        MoodEntry(timestamp: DateTime(2026, 1, 1, 14, 0), moodLevel: 3), // Afternoon
        MoodEntry(timestamp: DateTime(2026, 1, 1, 19, 0), moodLevel: 5), // Evening
        MoodEntry(timestamp: DateTime(2026, 1, 1, 23, 0), moodLevel: 2), // Night
      ];

      final slots = AdvancedInsightsUtils.computeTimeSlots(entries);
      expect(slots.length, 4);

      final morning = slots.firstWhere((s) => s.slot == TimeOfDaySlot.morning);
      expect(morning.averageMood, 4.0);

      final night = slots.firstWhere((s) => s.slot == TimeOfDaySlot.night);
      expect(night.averageMood, 2.0);
    });
  });
}
