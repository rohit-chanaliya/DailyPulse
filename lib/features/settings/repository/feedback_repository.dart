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

  /// Upper bound for the offline queue so it cannot grow without limit.
  static const int _maxPendingFeedback = 50;

  bool _isFlushing = false;

  /// Queues [tags] for [userId] and tries to send right away.
  ///
  /// Returns `true` if it reached Firestore, `false` if it is still queued.
  Future<bool> submit({
    required String userId,
    required List<String> tags,
  }) async {
    final entry = FeedbackEntry(userId: userId, tags: tags);
    final queue = [..._preferences.pendingFeedback, entry.toLocal()];
    if (queue.length > _maxPendingFeedback) {
      final dropped = queue.length - _maxPendingFeedback;
      queue.removeRange(0, dropped);
      appLogger.w('Feedback queue full, dropped $dropped oldest entries');
    }
    await _preferences.setPendingFeedback(queue);
    await flushPending(userId);
    return !_preferences.pendingFeedback.any((m) => m['id'] == entry.id);
  }

  /// Sends every queued entry that belongs to [userId]; failures stay queued.
  Future<void> flushPending(String userId) async {
    if (_isFlushing) return;
    _isFlushing = true;
    try {
      final pending = _preferences.pendingFeedback;
      final remaining = <Map<String, dynamic>>[];
      var changed = false;

      for (final map in pending) {
        if (map['userId'] != userId) {
          remaining.add(map);
          continue;
        }

        try {
          final entry = FeedbackEntry.fromLocal(map);
          if (await _firestoreService.addFeedback(entry)) {
            changed = true;
          } else {
            remaining.add(map);
          }
        } catch (e, stackTrace) {
          // A malformed entry can never be sent, so drop it instead of
          // retrying it forever.
          changed = true;
          appLogger.w(
            'Dropping invalid pending feedback entry',
            error: e,
            stackTrace: stackTrace,
          );
        }
      }

      if (changed) await _preferences.setPendingFeedback(remaining);
    } catch (e, stackTrace) {
      appLogger.e('Error flushing feedback', error: e, stackTrace: stackTrace);
    } finally {
      _isFlushing = false;
    }
  }
}
