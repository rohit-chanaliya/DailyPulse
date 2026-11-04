import 'package:dailypulse/core/utils/app_logger.dart';
import 'package:inject_annotation/inject_annotation.dart';

import '../datasource/hive_service.dart';
import '../models/mood_entry.dart';
import '../datasource/firestore_service.dart';
import '../services/sync_service.dart';

/// Coordinates local mood storage with background cloud sync.
@singleton
class MoodRepository {
  @inject
  MoodRepository(this._hiveService, this._syncService, this._firestoreService);

  final HiveService _hiveService;
  final SyncService _syncService;
  final FirestoreService _firestoreService;

  Future<void> addMoodEntry(MoodEntry entry, String userId) async {
    final entryWithUser = entry.copyWith(userId: userId);
    await _hiveService.put(entryWithUser);
    appLogger.d('Added mood entry locally for user: $userId');
    _syncService.syncPendingEntries();
  }

  void startBackgroundSync() {
    _syncService.startBackgroundSync();
  }

  void stopBackgroundSync() {
    _syncService.stopBackgroundSync();
  }

  int getPendingSyncCount() {
    return _syncService.getPendingSyncCount();
  }

  Future<bool> forceSyncNow() {
    return _syncService.forceSyncNow();
  }

  List<MoodEntry> getAllEntries(String? userId) {
    return _hiveService.getAllForUser(userId);
  }

  /// Emits [userId]'s entries whenever they change.
  Stream<List<MoodEntry>> watchEntries(String? userId) {
    return _hiveService.watchForUser(userId);
  }

  /// Deletes every local and remote trace of [userId].
  ///
  /// Returns `false` when the remote wipe failed, so the caller can keep the
  /// account alive instead of leaving orphaned data behind.
  Future<bool> deleteAccountData(String userId) async {
    try {
      await _firestoreService.deleteAccountData(userId);
      await _hiveService.deleteAllForUser(userId);
      appLogger.i('Deleted account data for user: $userId');
      return true;
    } catch (e, stackTrace) {
      appLogger.e(
        'Error deleting account data',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  // Fetch mood entries from Firebase and merge into local storage.
  //
  // Pending entries (id == null) are never deleted, and local data is never
  // replaced when the fetch fails — Firestore throws instead of returning [].
  Future<List<MoodEntry>> fetchAndSyncFromFirebase(String userId) async {
    try {
      appLogger.i('Starting Firebase fetch for user: $userId');
      final firebaseEntries = await _firestoreService.fetchMoodEntries(userId);

      appLogger.i('Fetched ${firebaseEntries.length} entries from Firebase');

      final localEntries = _hiveService.getAllForUser(userId);
      final localById = <String, MoodEntry>{
        for (final e in localEntries)
          if (e.id != null) e.id!: e,
      };
      final remoteIds = <String>{
        for (final e in firebaseEntries)
          if (e.id != null) e.id!,
      };

      // Reuse the existing localId for synced entries so a re-fetch does
      // not duplicate them (fromFirestore generates a fresh localId).
      final merged = firebaseEntries.map((remote) {
        final existing = remote.id == null ? null : localById[remote.id];
        if (existing == null) return remote;
        return remote.copyWith(localId: existing.localId);
      }).toList();

      // Propagate remote deletes, but only for this user's synced entries.
      // Pending uploads (id == null) and other users' data are untouched.
      for (final local in localEntries) {
        if (local.id != null &&
            local.userId == userId &&
            !remoteIds.contains(local.id)) {
          await _hiveService.delete(local.localId);
        }
      }
      await _hiveService.putAll(merged);

      appLogger.i('Merged ${merged.length} entries into local Hive');
      return _hiveService.getAllForUser(userId);
    } catch (e, stackTrace) {
      appLogger.e(
        'Error in fetchAndSyncFromFirebase',
        error: e,
        stackTrace: stackTrace,
      );
      // Return local entries if Firebase fetch fails
      return getAllEntries(userId);
    }
  }
}
