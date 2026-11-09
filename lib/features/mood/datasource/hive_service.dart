import 'package:hive_ce/hive.dart';
import 'package:inject_annotation/inject_annotation.dart';

import 'package:dailypulse/core/constant/constants.dart';

import '../models/mood_entry.dart';

/// Owns the Hive lifecycle and exposes the mood entries box.
///
/// The box is shared by every account that signs in on this device, so every
/// read must be scoped by `userId`. Unscoped reads are only for the
/// merge/delete paths that already know which user they are acting on.
@singleton
class HiveService {
  @inject
  HiveService(this._moodBox);

  static const String boxName = AppConstants.hiveBoxName;

  final Box<MoodEntry> _moodBox;

  /// Emits [userId]'s entries whenever the box changes.
  Stream<List<MoodEntry>> watchForUser(String? userId) {
    if (userId == null) return Stream.value(const <MoodEntry>[]);
    return _moodBox.watch().map((_) => getAllForUser(userId));
  }

  /// [userId]'s entries, newest first.
  List<MoodEntry> getAllForUser(String? userId) {
    if (userId == null) return const [];
    return _sorted(
      _moodBox.values.where((entry) => entry.userId == userId).toList(),
    );
  }

  /// [userId]'s entries that have not been pushed to Firestore yet.
  ///
  /// Oldest first so retries upload in the order the user created them.
  List<MoodEntry> getPendingForUser(String? userId) {
    if (userId == null) return const [];
    return _moodBox.values
        .where((entry) => entry.id == null && entry.userId == userId)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  /// Removes every local entry of [userId] (used when an account is deleted).
  Future<void> deleteAllForUser(String userId) async {
    final keys = _moodBox.values
        .where((entry) => entry.userId == userId)
        .map((entry) => entry.localId)
        .toList();
    await _moodBox.deleteAll(keys);
  }

  Future<void> put(MoodEntry entry) => _moodBox.put(entry.localId, entry);

  Future<void> putAll(Iterable<MoodEntry> entries) {
    return _moodBox.putAll({for (final e in entries) e.localId: e});
  }

  Future<void> delete(String localId) => _moodBox.delete(localId);

  static List<MoodEntry> _sorted(List<MoodEntry> entries) {
    return entries..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
}
