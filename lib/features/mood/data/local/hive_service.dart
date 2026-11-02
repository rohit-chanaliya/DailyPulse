import 'package:hive_ce_flutter/hive_flutter.dart';

import '../models/mood_entry.dart';

/// Owns the Hive lifecycle and exposes the mood entries box.
///
/// The box is shared by every account that signs in on this device, so every
/// read must be scoped by `userId`. Unscoped reads are only for the
/// merge/delete paths that already know which user they are acting on.
class HiveService {
  static const String boxName = 'mood_entries';
  static const String _directory = 'dailypulse';

  static late final Box<MoodEntry> moodBox;

  HiveService._();

  static Future<void> init() async {
    await Hive.initFlutter(_directory);

    if (!Hive.isAdapterRegistered(MoodEntryAdapter().typeId)) {
      Hive.registerAdapter(MoodEntryAdapter());
    }

    moodBox = await Hive.openBox<MoodEntry>(boxName);
  }

  /// Emits [userId]'s entries whenever the box changes.
  static Stream<List<MoodEntry>> watchForUser(String? userId) {
    if (userId == null) return Stream.value(const <MoodEntry>[]);
    return moodBox.watch().map((_) => getAllForUser(userId));
  }

  /// [userId]'s entries, newest first.
  static List<MoodEntry> getAllForUser(String? userId) {
    if (userId == null) return const [];
    return _sorted(
      moodBox.values.where((entry) => entry.userId == userId).toList(),
    );
  }

  /// [userId]'s entries that have not been pushed to Firestore yet.
  ///
  /// Oldest first so retries upload in the order the user created them.
  static List<MoodEntry> getPendingForUser(String? userId) {
    if (userId == null) return const [];
    return moodBox.values
        .where((entry) => entry.id == null && entry.userId == userId)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  /// Removes every local entry of [userId] (used when an account is deleted).
  static Future<void> deleteAllForUser(String userId) async {
    final keys = moodBox.values
        .where((entry) => entry.userId == userId)
        .map((entry) => entry.localId)
        .toList();
    await moodBox.deleteAll(keys);
  }

  static Future<void> put(MoodEntry entry) => moodBox.put(entry.localId, entry);

  static Future<void> putAll(Iterable<MoodEntry> entries) {
    return moodBox.putAll({for (final e in entries) e.localId: e});
  }

  static Future<void> delete(String localId) => moodBox.delete(localId);

  static List<MoodEntry> _sorted(List<MoodEntry> entries) {
    return entries..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
}
