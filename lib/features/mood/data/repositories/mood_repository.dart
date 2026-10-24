import 'package:dailypulse/core/utils/app_logger.dart';
import 'package:inject_annotation/inject_annotation.dart';

import '../local/hive_service.dart';
import '../models/mood_entry.dart';
import '../remote/firestore_service.dart';
import '../services/sync_service.dart';

/// Coordinates local mood storage with background cloud sync.
@singleton
class MoodRepository {
  @inject
  MoodRepository(this._syncService, this._firestoreService);

  final SyncService _syncService;
  final FirestoreService _firestoreService;

  Future<void> addMoodEntry(MoodEntry entry, String userId) async {
    final entryWithUser = entry.copyWith(userId: userId);
    await HiveService.put(entryWithUser);
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

  List<MoodEntry> getAllEntries() {
    return HiveService.getAll();
  }

  /// Emits local entries whenever they change.
  Stream<List<MoodEntry>> watchEntries() {
    return HiveService.watchAll();
  }

  // Fetch mood entries from Firebase and sync to local storage
  Future<List<MoodEntry>> fetchAndSyncFromFirebase(String userId) async {
    try {
      appLogger.i('Starting Firebase fetch for user: $userId');
      final firebaseEntries = await _firestoreService.fetchMoodEntries(userId);

      appLogger.i('Fetched ${firebaseEntries.length} entries from Firebase');

      // Replace local storage with the Firebase snapshot
      await HiveService.clear();
      await HiveService.putAll(firebaseEntries);

      appLogger.i('Synced ${firebaseEntries.length} entries to local Hive');
      return HiveService.getAll();
    } catch (e, stackTrace) {
      appLogger.e(
        'Error in fetchAndSyncFromFirebase',
        error: e,
        stackTrace: stackTrace,
      );
      // Return local entries if Firebase fetch fails
      return getAllEntries();
    }
  }

  // Stream mood entries from Firebase
  Stream<List<MoodEntry>> streamMoodEntries(String userId) {
    return _firestoreService.streamMoodEntries(userId);
  }
}
