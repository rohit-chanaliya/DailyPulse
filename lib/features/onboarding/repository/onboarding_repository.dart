import 'package:inject_annotation/inject_annotation.dart';

import 'package:dailypulse/core/services/app_preferences.dart';

/// Tracks whether the first-run onboarding has been completed.
@singleton
class OnboardingRepository {
  @inject
  OnboardingRepository(this._preferences);

  final AppPreferences _preferences;

  bool get hasSeenOnboarding => _preferences.hasSeenOnboarding;

  Future<void> markSeen() => _preferences.setHasSeenOnboarding(true);
}
