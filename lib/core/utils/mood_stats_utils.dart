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
}
