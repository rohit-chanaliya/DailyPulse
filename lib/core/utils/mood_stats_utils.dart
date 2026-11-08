import '../../features/mood/models/mood_entry.dart';

/// Aggregations over mood entries shared by History and Insights.
abstract final class MoodStatsUtils {
  static int daysInYear(int year) =>
      DateTime(year + 1).difference(DateTime(year)).inDays;

  /// Number of distinct calendar days in [year] that have at least one entry.
  static int daysLoggedInYear(List<MoodEntry> entries, int year) {
    return {
      for (final e in entries)
        if (e.timestamp.year == year)
          DateTime(e.timestamp.year, e.timestamp.month, e.timestamp.day),
    }.length;
  }

  /// Most frequent mood level, or `null` when there are no entries.
  /// Ties resolve to the most recent entry's level.
  static int? dominantLevel(List<MoodEntry> entries) {
    if (entries.isEmpty) return null;
    final counts = <int, int>{};
    for (final e in entries) {
      counts.update(e.moodLevel, (c) => c + 1, ifAbsent: () => 1);
    }
    final best = counts.values.reduce((a, b) => a > b ? a : b);
    final latest = [...entries]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return latest.firstWhere((e) => counts[e.moodLevel] == best).moodLevel;
  }

  /// Distinct calendar days (time stripped) that have at least one entry.
  static Set<DateTime> loggedDays(List<MoodEntry> entries) => {
    for (final e in entries)
      DateTime(e.timestamp.year, e.timestamp.month, e.timestamp.day),
  };

  /// Consecutive logged days ending today, or yesterday if today is empty.
  static int currentStreak(List<MoodEntry> entries, {DateTime? now}) {
    final days = loggedDays(entries);
    final today = now ?? DateTime.now();
    var cursor = DateTime(today.year, today.month, today.day);
    if (!days.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    var streak = 0;
    while (days.contains(cursor)) {
      streak++;
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }
    return streak;
  }

  /// Average mood of the last [days] days scaled to 0-100, or `null` if empty.
  static int? moodScore(
    List<MoodEntry> entries, {
    int days = 30,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final since = reference.subtract(Duration(days: days));
    final recent = entries.where((e) => !e.timestamp.isBefore(since)).toList();
    if (recent.isEmpty) return null;
    final average =
        recent.map((e) => e.moodLevel).reduce((a, b) => a + b) / recent.length;
    return (average / 5 * 100).round();
  }

  /// Mood levels of the latest [count] entries, oldest first.
  static List<int> recentLevels(List<MoodEntry> entries, int count) {
    final sorted = [...entries]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final tail = sorted.length > count
        ? sorted.sublist(sorted.length - count)
        : sorted;
    return [for (final e in tail) e.moodLevel];
  }

  /// Stress from 1 (low) to 5 (high): share of low moods (levels 0-2) in the
  /// last [days] days, or `null` when there are no entries in that window.
  static int? stressLevel(
    List<MoodEntry> entries, {
    int days = 7,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final since = reference.subtract(Duration(days: days));
    final recent = entries.where((e) => !e.timestamp.isBefore(since)).toList();
    if (recent.isEmpty) return null;
    final low = recent.where((e) => e.moodLevel <= 2).length;
    return (low / recent.length * 4).round() + 1;
  }
}
