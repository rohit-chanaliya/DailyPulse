import 'package:inject_annotation/inject_annotation.dart';

import 'package:dailypulse/core/services/app_preferences.dart';

/// Tracks whether the first-run onboarding has been completed.
@singleton
class OnboardingRepository {
  @inject
  OnboardingRepository();

  bool get hasSeenOnboarding => AppPreferences.hasSeenOnboarding;

  Future<void> markSeen() => AppPreferences.setHasSeenOnboarding(true);
}
