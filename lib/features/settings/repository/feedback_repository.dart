import 'package:inject_annotation/inject_annotation.dart';

import 'package:dailypulse/core/services/app_preferences.dart';
import 'package:dailypulse/core/utils/app_logger.dart';
import 'package:dailypulse/features/mood/datasource/firestore_service.dart';
import 'package:dailypulse/features/settings/models/feedback_entry.dart';

/// Saves feedback locally first, then pushes it to Firestore in the background.
@singleton
class FeedbackRepository {
  @inject
  FeedbackRepository(this._preferences, this._firestoreService);

  final AppPreferences _preferences;
  final FirestoreService _firestoreService;

  bool _isFlushing = false;

  /// Queues [tags] for [userId] and tries to send right away.
  ///
  /// Returns `true` if it reached Firestore, `false` if it is still queued.
  Future<bool> submit({
    required String userId,
    required List<String> tags,
  }) async {
    final entry = FeedbackEntry(userId: userId, tags: tags);
    await _preferences.setPendingFeedback([
      ..._preferences.pendingFeedback,
      entry.toLocal(),
    ]);
    await flushPending(userId);
    return !_preferences.pendingFeedback.any((m) => m['id'] == entry.id);
  }

  /// Sends every queued entry that belongs to [userId]; failures stay queued.
  Future<void> flushPending(String userId) async {
    if (_isFlushing) return;
    _isFlushing = true;
    try {
      for (final map in _preferences.pendingFeedback) {
        if (map['userId'] != userId) continue;
        final entry = FeedbackEntry.fromLocal(map);
        if (await _firestoreService.addFeedback(entry)) {
          await _preferences.setPendingFeedback([
            for (final m in _preferences.pendingFeedback)
              if (m['id'] != entry.id) m,
          ]);
        }
      }
    } catch (e, stackTrace) {
      appLogger.e('Error flushing feedback', error: e, stackTrace: stackTrace);
    } finally {
      _isFlushing = false;
    }
  }
}
