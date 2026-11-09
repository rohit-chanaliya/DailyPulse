import 'dart:async';

import 'package:inject_annotation/inject_annotation.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/utils/app_logger.dart';
import '../../auth/viewmodels/auth_signal.dart';
import '../models/mood_entry.dart';
import '../repository/mood_repository.dart';

/// Mood entries and loading state backed by signals.
///
/// Every read is scoped to the signed-in user: the Hive box is shared by every
/// account on this device, so unscoped reads would leak another user's moods.
///
/// The [entries] signal is kept in sync with Hive for the whole session, so
/// background syncs and account switches update the UI without manual reloads.
@singleton
class MoodSignal {
  @inject
  MoodSignal(this._repository, this._authSignal) {
    _authEffect = effect(() {
      _bindToUser(_authSignal.user.value?.uid);
    });
  }

  final MoodRepository _repository;
  final AuthSignal _authSignal;

  final isLoading = signal(false);
  final entries = signal<List<MoodEntry>>(const []);
  final newestFirst = signal(true);

  /// [entries] in the order chosen by [newestFirst].
  late final orderedEntries = computed<List<MoodEntry>>(() {
    final list = entries.value;
    return newestFirst.value ? list : list.reversed.toList(growable: false);
  });

  EffectCleanup? _authEffect;
  StreamSubscription<List<MoodEntry>>? _entriesSubscription;
  String? _boundUserId;

  Future<bool> saveMood({
    required int moodLevel,
    required String userId,
    String? note,
    DateTime? timestamp,
    String? title,
    List<String> tags = const [],
  }) async {
    isLoading.value = true;
    try {
      final entry = MoodEntry(
        timestamp: timestamp ?? DateTime.now(),
        moodLevel: moodLevel,
        note: note?.isEmpty ?? true ? null : note,
        userId: userId,
        title: title?.isEmpty ?? true ? null : title,
        tags: tags,
      );

      await _repository.addMoodEntry(entry, userId);
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

  void startBackgroundSync() {
    _repository.startBackgroundSync();
  }

  void stopBackgroundSync() {
    _repository.stopBackgroundSync();
  }

  int getPendingSyncCount() {
    return _repository.getPendingSyncCount();
  }

  /// Subscribes [entries] to [userId]'s Hive box and drops the old subscription.
  void _bindToUser(String? userId) {
    if (userId == _boundUserId) return;
    _boundUserId = userId;

    _entriesSubscription?.cancel();
    _entriesSubscription = null;

    if (userId == null) {
      entries.value = const [];
      return;
    }

    entries.value = _repository.getAllEntries(userId);
    _entriesSubscription = _repository.watchEntries(userId).listen(
      (list) => entries.value = list,
      onError: (Object error, StackTrace stackTrace) {
        appLogger.e(
          'Mood entries stream error',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  void dispose() {
    _authEffect?.call();
    _authEffect = null;
    _entriesSubscription?.cancel();
    _entriesSubscription = null;
  }
}
