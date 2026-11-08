import '../../features/mood/models/mood_entry.dart';

class TagMoodStat {
  const TagMoodStat({
    required this.tag,
    required this.count,
    required this.averageMood,
    required this.moodDelta,
  });

  final String tag;
  final int count;
  final double averageMood;
  final double moodDelta;
}

class DayPatternInsight {
  const DayPatternInsight({
    required this.bestDayName,
    required this.bestDayAverage,
    required this.worstDayName,
    required this.worstDayAverage,
  });

  final String? bestDayName;
  final double? bestDayAverage;
  final String? worstDayName;
  final double? worstDayAverage;
}

enum TimeOfDaySlot { morning, afternoon, evening, night }

class TimeSlotInsight {
  const TimeSlotInsight({
    required this.slot,
    required this.count,
    required this.averageMood,
  });

  final TimeOfDaySlot slot;
  final int count;
  final double averageMood;
}

abstract final class AdvancedInsightsUtils {
  static const weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static List<TagMoodStat> computeTagStats(List<MoodEntry> entries) {
    if (entries.isEmpty) return const [];

    final overallAverage =
        entries.map((e) => e.moodLevel).reduce((a, b) => a + b) /
            entries.length;

    final tagsMap = <String, List<int>>{};
    for (final e in entries) {
      for (final tag in e.tags) {
        if (tag.trim().isNotEmpty) {
          tagsMap.putIfAbsent(tag.trim(), () => <int>[]).add(e.moodLevel);
        }
      }
    }

    if (tagsMap.isEmpty) return const [];

    final stats = [
      for (final entry in tagsMap.entries)
        TagMoodStat(
          tag: entry.key,
          count: entry.value.length,
          averageMood:
              entry.value.reduce((a, b) => a + b) / entry.value.length,
          moodDelta: (entry.value.reduce((a, b) => a + b) /
                  entry.value.length) -
              overallAverage,
        ),
    ];

    stats.sort((a, b) => b.averageMood.compareTo(a.averageMood));
    return stats;
  }

  static DayPatternInsight computeDayPattern(List<MoodEntry> entries) {
    if (entries.isEmpty) {
      return const DayPatternInsight(
        bestDayName: null,
        bestDayAverage: null,
        worstDayName: null,
        worstDayAverage: null,
      );
    }

    final dayBuckets = <int, List<int>>{};
    for (final e in entries) {
      dayBuckets.putIfAbsent(e.timestamp.weekday, () => <int>[]).add(e.moodLevel);
    }

    if (dayBuckets.isEmpty) {
      return const DayPatternInsight(
        bestDayName: null,
        bestDayAverage: null,
        worstDayName: null,
        worstDayAverage: null,
      );
    }

    final dayAverages = dayBuckets.map(
      (dayIndex, levels) => MapEntry(
        dayIndex,
        levels.reduce((a, b) => a + b) / levels.length,
      ),
    );

    int? bestDay;
    double? bestAvg;
    int? worstDay;
    double? worstAvg;

    for (final entry in dayAverages.entries) {
      if (bestAvg == null || entry.value > bestAvg) {
        bestAvg = entry.value;
        bestDay = entry.key;
      }
      if (worstAvg == null || entry.value < worstAvg) {
        worstAvg = entry.value;
        worstDay = entry.key;
      }
    }

    return DayPatternInsight(
      bestDayName: bestDay != null ? weekdays[bestDay - 1] : null,
      bestDayAverage: bestAvg,
      worstDayName: worstDay != null ? weekdays[worstDay - 1] : null,
      worstDayAverage: worstAvg,
    );
  }

  static List<TimeSlotInsight> computeTimeSlots(List<MoodEntry> entries) {
    if (entries.isEmpty) return const [];

    final buckets = <TimeOfDaySlot, List<int>>{
      TimeOfDaySlot.morning: [],
      TimeOfDaySlot.afternoon: [],
      TimeOfDaySlot.evening: [],
      TimeOfDaySlot.night: [],
    };

    for (final e in entries) {
      final hour = e.timestamp.hour;
      final slot = switch (hour) {
        >= 5 && < 12 => TimeOfDaySlot.morning,
        >= 12 && < 17 => TimeOfDaySlot.afternoon,
        >= 17 && < 21 => TimeOfDaySlot.evening,
        _ => TimeOfDaySlot.night,
      };
      buckets[slot]!.add(e.moodLevel);
    }

    return [
      for (final slot in TimeOfDaySlot.values)
        if (buckets[slot]!.isNotEmpty)
          TimeSlotInsight(
            slot: slot,
            count: buckets[slot]!.length,
            averageMood:
                buckets[slot]!.reduce((a, b) => a + b) / buckets[slot]!.length,
          ),
    ];
  }
}
