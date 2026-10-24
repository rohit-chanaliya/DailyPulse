import 'package:inject_annotation/inject_annotation.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/utils/app_logger.dart';
import '../../data/models/mood_entry.dart';
import '../../data/repositories/mood_repository.dart';

/// Mood entries and loading state backed by signals.
@singleton
class MoodSignal {
  @inject
  MoodSignal(this._repository);

  final MoodRepository _repository;

  final isLoading = signal(false);
  final entries = signal<List<MoodEntry>>(const []);

  Future<bool> saveMood({
    required int moodLevel,
    required String userId,
    String? note,
  }) async {
    isLoading.value = true;
    try {
      final entry = MoodEntry(
        timestamp: DateTime.now(),
        moodLevel: moodLevel,
        note: note?.isEmpty ?? true ? null : note,
        userId: userId,
      );

      await _repository.addMoodEntry(entry, userId);
      entries.value = _repository.getAllEntries();
      appLogger.i('Mood saved successfully: level $moodLevel');
      return true;
    } catch (e, stackTrace) {
      appLogger.e('Error saving mood', error: e, stackTrace: stackTrace);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoodEntries(String userId) async {
    isLoading.value = true;
    try {
      entries.value = await _repository.fetchAndSyncFromFirebase(userId);
      appLogger.d('Fetched ${entries.value.length} mood entries');
    } catch (e, stackTrace) {
      appLogger.e(
        'Error fetching mood entries',
        error: e,
        stackTrace: stackTrace,
      );
      entries.value = _repository.getAllEntries();
    } finally {
      isLoading.value = false;
    }
  }

  /// Locally cached entries, refreshed on every write.
  void reloadLocalEntries() {
    entries.value = _repository.getAllEntries();
  }

  Stream<List<MoodEntry>> streamMoodEntries(String userId) {
    return _repository.streamMoodEntries(userId);
  }

  Stream<List<MoodEntry>> watchLocalEntries() {
    return _repository.watchEntries();
  }

  void startBackgroundSync() {
    _repository.startBackgroundSync();
  }

  void stopBackgroundSync() {
    _repository.stopBackgroundSync();
  }

  int getPendingSyncCount() {
    return _repository.getPendingSyncCount();
  }
}
