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
  static const String _reminderEnabledKey = 'reminder_enabled';
  static const String _reminderHourKey = 'reminder_hour';
  static const String _reminderMinuteKey = 'reminder_minute';
  static const String _reminderSoundKey = 'reminder_sound';
  static const String _reminderVibrationKey = 'reminder_vibration';
  static const String _pendingFeedbackKey = 'pending_feedback';

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

  bool get isReminderEnabled =>
      _box.get(_reminderEnabledKey, defaultValue: false) as bool;

  Future<void> setReminderEnabled(bool value) =>
      _box.put(_reminderEnabledKey, value);

  int get reminderHour =>
      _box.get(_reminderHourKey, defaultValue: 20) as int;

  Future<void> setReminderHour(int value) =>
      _box.put(_reminderHourKey, value);

  int get reminderMinute =>
      _box.get(_reminderMinuteKey, defaultValue: 0) as int;

  Future<void> setReminderMinute(int value) =>
      _box.put(_reminderMinuteKey, value);

  bool get isReminderSoundEnabled =>
      _box.get(_reminderSoundKey, defaultValue: true) as bool;

  Future<void> setReminderSoundEnabled(bool value) =>
      _box.put(_reminderSoundKey, value);

  bool get isReminderVibrationEnabled =>
      _box.get(_reminderVibrationKey, defaultValue: true) as bool;

  Future<void> setReminderVibrationEnabled(bool value) =>
      _box.put(_reminderVibrationKey, value);

  /// Feedback entries (as plain maps) waiting to be sent to Firestore.
  List<Map<String, dynamic>> get pendingFeedback {
    final raw = _box.get(_pendingFeedbackKey) as List<dynamic>? ?? const [];
    return [for (final item in raw) Map<String, dynamic>.from(item as Map)];
  }

  Future<void> setPendingFeedback(List<Map<String, dynamic>> items) =>
      _box.put(_pendingFeedbackKey, items);

  String? getProfileImagePath(String userId) =>
      _box.get('profile_image_$userId') as String?;

  Future<void> setProfileImagePath(String userId, String? path) =>
      path != null
          ? _box.put('profile_image_$userId', path)
          : _box.delete('profile_image_$userId');
}
