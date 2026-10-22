import 'package:hive_ce/hive.dart';

/// Lightweight local preferences backed by Hive.
///
/// This lives separately from the mood entries box so onboarding and theme
/// state never get wiped when mood data is re-synced from Firestore.
class AppPreferences {
  AppPreferences._();

  static const String _boxName = 'app_preferences';
  static const String _onboardingSeenKey = 'has_seen_onboarding';

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
}
