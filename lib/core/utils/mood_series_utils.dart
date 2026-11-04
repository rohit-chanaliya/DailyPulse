import '../../features/mood/models/mood_entry.dart';

/// How entries are grouped along the mood chart's x-axis.
enum MoodGranularity { all, days, weeks, months, years }

/// Average mood level (0..5) of one bucket of entries.
class MoodPoint {
  const MoodPoint({required this.start, required this.level});

  final DateTime start;
  final double level;
}

/// Builds chart series from raw entries.
abstract final class MoodSeriesUtils {
  static const int maxAllPoints = 40;

  /// Chronological points; buckets without entries are skipped.
  static List<MoodPoint> series(
    List<MoodEntry> entries,
    MoodGranularity granularity,
  ) {
    if (entries.isEmpty) return const [];
    final sorted = [...entries]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (granularity == MoodGranularity.all) {
      return [
        for (final e in sorted.reversed.take(maxAllPoints).toList().reversed)
          MoodPoint(start: e.timestamp, level: e.moodLevel.toDouble()),
      ];
    }

    final buckets = <DateTime, List<int>>{};
    for (final e in sorted) {
      buckets
          .putIfAbsent(_bucketStart(e.timestamp, granularity), () => [])
          .add(e.moodLevel);
    }

    final points = [
      for (final b in buckets.entries)
        MoodPoint(
          start: b.key,
          level: b.value.reduce((a, c) => a + c) / b.value.length,
        ),
    ];
    final limit = switch (granularity) {
      MoodGranularity.days => 14,
      MoodGranularity.weeks => 12,
      MoodGranularity.months => 12,
      _ => points.length,
    };
    return points.length <= limit
        ? points
        : points.sublist(points.length - limit);
  }

  /// Average level per weekday for the week containing [anchor] (Mon..Sun);
  /// `null` for days without entries.
  static List<double?> weekAverages(List<MoodEntry> entries, DateTime anchor) {
    final monday = DateTime(
      anchor.year,
      anchor.month,
      anchor.day,
    ).subtract(Duration(days: anchor.weekday - 1));
    return [
      for (var i = 0; i < 7; i++)
        _dayAverage(entries, DateTime(monday.year, monday.month, monday.day + i)),
    ];
  }

  /// Average level for each of the [days] days ending on [anchor], oldest first.
  static List<double?> lastDaysAverages(
    List<MoodEntry> entries,
    int days,
    DateTime anchor,
  ) {
    return [
      for (var i = days - 1; i >= 0; i--)
        _dayAverage(
          entries,
          DateTime(anchor.year, anchor.month, anchor.day - i),
        ),
    ];
  }

  static double? _dayAverage(List<MoodEntry> entries, DateTime day) {
    final levels = [
      for (final e in entries)
        if (e.timestamp.year == day.year &&
            e.timestamp.month == day.month &&
            e.timestamp.day == day.day)
          e.moodLevel,
    ];
    if (levels.isEmpty) return null;
    return levels.reduce((a, b) => a + b) / levels.length;
  }

  static DateTime _bucketStart(DateTime t, MoodGranularity g) {
    final day = DateTime(t.year, t.month, t.day);
    return switch (g) {
      MoodGranularity.weeks => day.subtract(Duration(days: day.weekday - 1)),
      MoodGranularity.months => DateTime(t.year, t.month),
      MoodGranularity.years => DateTime(t.year),
      _ => day,
    };
  }
}
