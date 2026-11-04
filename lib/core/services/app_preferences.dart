import 'package:flutter/material.dart' show ThemeMode;
import 'package:hive_ce/hive.dart';
import 'package:inject_annotation/inject_annotation.dart';

/// Lightweight local preferences backed by Hive.
///
/// This lives separately from the mood entries box so onboarding and theme
/// state never get wiped when mood data is re-synced from Firestore.
@singleton
class AppPreferences {
  @inject
  AppPreferences(this._box);

  static const String boxName = 'app_preferences';
  static const String _onboardingSeenKey = 'has_seen_onboarding';
  static const String _themeModeKey = 'theme_mode';

  final Box<dynamic> _box;

  static Future<void> init() async {
    await Hive.openBox<dynamic>(boxName);
  }

  bool get hasSeenOnboarding {
    return _box.get(_onboardingSeenKey, defaultValue: false) as bool;
  }

  Future<void> setHasSeenOnboarding(bool value) {
    return _box.put(_onboardingSeenKey, value);
  }

  /// Theme the user picked in Settings; [ThemeMode.system] when never set.
  ThemeMode get themeMode => switch (_box.get(_themeModeKey)) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  Future<void> setThemeMode(ThemeMode mode) {
    return _box.put(_themeModeKey, switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    });
  }
}
