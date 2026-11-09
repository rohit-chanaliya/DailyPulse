import 'package:hive_ce/hive.dart';
import 'package:inject_annotation/inject_annotation.dart';

import 'package:dailypulse/core/utils/app_logger.dart';

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

  bool get hasSeenOnboarding {
    return _readBool(_onboardingSeenKey, fallback: false);
  }

  Future<void> setHasSeenOnboarding(bool value) {
    return _box.put(_onboardingSeenKey, value);
  }

  bool get isReminderEnabled => _readBool(_reminderEnabledKey, fallback: false);

  Future<void> setReminderEnabled(bool value) =>
      _box.put(_reminderEnabledKey, value);

  int get reminderHour => _readInt(_reminderHourKey, fallback: 20);

  Future<void> setReminderHour(int value) => _box.put(_reminderHourKey, value);

  int get reminderMinute => _readInt(_reminderMinuteKey, fallback: 0);

  Future<void> setReminderMinute(int value) =>
      _box.put(_reminderMinuteKey, value);

  bool get isReminderSoundEnabled =>
      _readBool(_reminderSoundKey, fallback: true);

  Future<void> setReminderSoundEnabled(bool value) =>
      _box.put(_reminderSoundKey, value);

  bool get isReminderVibrationEnabled =>
      _readBool(_reminderVibrationKey, fallback: true);

  Future<void> setReminderVibrationEnabled(bool value) =>
      _box.put(_reminderVibrationKey, value);

  /// Feedback entries (as plain maps) waiting to be sent to Firestore.
  List<Map<String, dynamic>> get pendingFeedback {
    final raw = _read(_pendingFeedbackKey);
    if (raw == null) return const [];
    if (raw is! List) {
      _warnWrongType(_pendingFeedbackKey, raw);
      return const [];
    }

    final entries = <Map<String, dynamic>>[];
    for (final item in raw) {
      if (item is Map) {
        entries.add(Map<String, dynamic>.from(item));
      } else {
        appLogger.w('Skipping invalid entry in "$_pendingFeedbackKey"');
      }
    }
    return entries;
  }

  Future<void> setPendingFeedback(List<Map<String, dynamic>> items) =>
      _box.put(_pendingFeedbackKey, items);

  String? getProfileImagePath(String userId) =>
      _readString('profile_image_$userId');

  Future<void> setProfileImagePath(String userId, String? path) => path != null
      ? _box.put('profile_image_$userId', path)
      : _box.delete('profile_image_$userId');

  bool _readBool(String key, {required bool fallback}) {
    final value = _read(key);
    if (value is bool) return value;
    _warnWrongType(key, value);
    return fallback;
  }

  int _readInt(String key, {required int fallback}) {
    final value = _read(key);
    if (value is int) return value;
    _warnWrongType(key, value);
    return fallback;
  }

  String? _readString(String key) {
    final value = _read(key);
    if (value is String) return value;
    _warnWrongType(key, value);
    return null;
  }

  /// Reads a value without ever throwing on a corrupt or closed box.
  Object? _read(String key) {
    try {
      return _box.get(key);
    } catch (e, stackTrace) {
      appLogger.e(
        'Failed to read preference "$key"',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  void _warnWrongType(String key, Object? value) {
    if (value == null) return;
    appLogger.w('Ignoring invalid preference "$key" (${value.runtimeType})');
  }
}
