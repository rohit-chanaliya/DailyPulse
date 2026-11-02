import 'package:flutter/material.dart' show ThemeMode;
import 'package:hive_ce/hive.dart';

/// Lightweight local preferences backed by Hive.
///
/// This lives separately from the mood entries box so onboarding and theme
/// state never get wiped when mood data is re-synced from Firestore.
class AppPreferences {
  AppPreferences._();

  static const String _boxName = 'app_preferences';
  static const String _onboardingSeenKey = 'has_seen_onboarding';
  static const String _themeModeKey = 'theme_mode';

  static late final Box<dynamic> _box;

  static Future<void> init() async {
    _box = await Hive.openBox<dynamic>(_boxName);
  }

  static bool get hasSeenOnboarding {
    return _box.get(_onboardingSeenKey, defaultValue: false) as bool;
  }

  static Future<void> setHasSeenOnboarding(bool value) {
    return _box.put(_onboardingSeenKey, value);
  }

  /// Theme the user picked in Settings; [ThemeMode.system] when never set.
  static ThemeMode get themeMode => switch (_box.get(_themeModeKey)) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  static Future<void> setThemeMode(ThemeMode mode) {
    return _box.put(_themeModeKey, switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    });
  }
}
