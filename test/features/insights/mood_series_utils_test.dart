import 'package:dailypulse/core/utils/mood_series_utils.dart';
import 'package:dailypulse/features/mood/models/mood_entry.dart';
import 'package:flutter_test/flutter_test.dart';

MoodEntry entry(DateTime at, int level) {
  return MoodEntry(timestamp: at, moodLevel: level);
}

void main() {
  group('MoodSeriesUtils.series', () {
    test('returns no points for an empty list', () {
      expect(
        MoodSeriesUtils.series(const [], MoodGranularity.weeks),
        isEmpty,
      );
    });

    test('averages multiple entries inside the same day bucket', () {
      final points = MoodSeriesUtils.series(
        [
          entry(DateTime(2026, 11, 2, 9), 1),
          entry(DateTime(2026, 11, 2, 18), 5),
          entry(DateTime(2026, 11, 3, 10), 4),
        ],
        MoodGranularity.days,
      );

      expect(points.length, 2);
      expect(points.first.level, 3.0);
      expect(points.last.level, 4.0);
    });
  });

  group('MoodSeriesUtils.weekAverages', () {
    test('returns Monday-first averages with null gaps', () {
      final week = MoodSeriesUtils.weekAverages(
        [
          entry(DateTime(2026, 11, 2, 10), 2), // Monday
          entry(DateTime(2026, 11, 4, 10), 4), // Wednesday
        ],
        DateTime(2026, 11, 4),
      );

      expect(week.length, 7);
      expect(week[0], 2.0);
      expect(week[1], isNull);
      expect(week[2], 4.0);
      expect(week.sublist(3), everyElement(isNull));
    });
  });

  group('MoodSeriesUtils.lastDaysAverages', () {
    test('returns the requested number of days, oldest first', () {
      final averages = MoodSeriesUtils.lastDaysAverages(
        [
          entry(DateTime(2026, 11, 3, 10), 1),
          entry(DateTime(2026, 11, 4, 10), 5),
        ],
        2,
        DateTime(2026, 11, 4),
      );

      expect(averages, [1.0, 5.0]);
    });
  });
}
