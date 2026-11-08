import 'package:inject_annotation/inject_annotation.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/utils/app_logger.dart';
import 'package:dailypulse/features/auth/viewmodels/auth_signal.dart';
import 'package:dailypulse/features/settings/models/feedback_tag.dart';
import 'package:dailypulse/features/settings/repository/feedback_repository.dart';

enum FeedbackOutcome { sent, queued, failed, notSignedIn }

/// Selected improvement areas and the submit action.
@singleton
class FeedbackSignal {
  @inject
  FeedbackSignal(this._repository, this._authSignal);

  final FeedbackRepository _repository;
  final AuthSignal _authSignal;

  final selected = signal<Set<FeedbackTag>>(const {});
  final isSubmitting = signal(false);

  void toggle(FeedbackTag tag) {
    final next = {...selected.value};
    if (!next.remove(tag)) next.add(tag);
    selected.value = next;
  }

  void reset() => selected.value = const {};

  Future<FeedbackOutcome> submit() async {
    final userId = _authSignal.user.value?.uid;
    if (userId == null) return FeedbackOutcome.notSignedIn;
    if (selected.value.isEmpty) return FeedbackOutcome.failed;

    isSubmitting.value = true;
    try {
      final sent = await _repository.submit(
        userId: userId,
        tags: [for (final tag in FeedbackTag.values) if (selected.value.contains(tag)) tag.id],
      );
      reset();
      return sent ? FeedbackOutcome.sent : FeedbackOutcome.queued;
    } catch (e, stackTrace) {
      appLogger.e('Failed to submit feedback', error: e, stackTrace: stackTrace);
      return FeedbackOutcome.failed;
    } finally {
      isSubmitting.value = false;
    }
  }
}
