import 'package:inject_annotation/inject_annotation.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/utils/app_logger.dart';
import '../../../auth/presentation/signals/auth_signal.dart';
import '../../data/models/mood_entry.dart';
import '../../data/repositories/mood_repository.dart';

/// Mood entries and loading state backed by signals.
///
/// Every read is scoped to the signed-in user: the Hive box is shared by every
/// account on this device, so unscoped reads would leak another user's moods.
@singleton
class MoodSignal {
  @inject
  MoodSignal(this._repository, this._authSignal);

  final MoodRepository _repository;
  final AuthSignal _authSignal;

  final isLoading = signal(false);
  final entries = signal<List<MoodEntry>>(const []);

  /// The signed-in user's id, or `null` when nobody is signed in.
  String? get _userId => _authSignal.user.value?.uid;

  Future<bool> saveMood({
    required int moodLevel,
    required String userId,
    String? note,
    DateTime? timestamp,
    String? title,
  }) async {
    isLoading.value = true;
    try {
      final entry = MoodEntry(
        timestamp: timestamp ?? DateTime.now(),
        moodLevel: moodLevel,
        note: note?.isEmpty ?? true ? null : note,
        userId: userId,
        title: title?.isEmpty ?? true ? null : title,
      );

      await _repository.addMoodEntry(entry, userId);
      entries.value = _repository.getAllEntries(userId);
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
      entries.value = _repository.getAllEntries(userId);
    } finally {
      isLoading.value = false;
    }
  }

  /// Locally cached entries of the signed-in user, refreshed on every write.
  void reloadLocalEntries() {
    entries.value = _repository.getAllEntries(_userId);
  }

  Stream<List<MoodEntry>> streamMoodEntries(String userId) {
    return _repository.streamMoodEntries(userId);
  }

  Stream<List<MoodEntry>> watchLocalEntries() {
    return _repository.watchEntries(_userId);
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
