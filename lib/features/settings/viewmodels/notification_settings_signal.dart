import 'package:inject_annotation/inject_annotation.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/services/app_preferences.dart';
import 'package:dailypulse/core/services/notification_service.dart';

/// Daily reminder, sound and vibration preferences backed by signals.
@singleton
class NotificationSettingsSignal {
  @inject
  NotificationSettingsSignal(this._preferences, this._service);

  final AppPreferences _preferences;
  final NotificationService _service;

  late final reminderEnabled = signal(_preferences.isReminderEnabled);
  late final hour = signal(_preferences.reminderHour);
  late final minute = signal(_preferences.reminderMinute);
  late final soundEnabled = signal(_preferences.isReminderSoundEnabled);
  late final vibrationEnabled = signal(_preferences.isReminderVibrationEnabled);

  /// Turns the reminder on or off. Returns `false` if permission was denied.
  Future<bool> setReminderEnabled(bool value) async {
    if (value) {
      if (!await _service.requestPermission()) {
        reminderEnabled.value = false;
        return false;
      }
      await _service.scheduleDailyReminder(
        hour: hour.value,
        minute: minute.value,
      );
    } else {
      await _service.cancelDailyReminder();
    }
    reminderEnabled.value = value;
    return true;
  }

  Future<void> setTime({required int newHour, required int newMinute}) async {
    hour.value = newHour;
    minute.value = newMinute;
    if (reminderEnabled.value) {
      await _service.scheduleDailyReminder(hour: newHour, minute: newMinute);
    } else {
      await _preferences.setReminderHour(newHour);
      await _preferences.setReminderMinute(newMinute);
    }
  }

  Future<void> setSoundEnabled(bool value) async {
    soundEnabled.value = value;
    await _preferences.setReminderSoundEnabled(value);
    await _reschedule();
  }

  Future<void> setVibrationEnabled(bool value) async {
    vibrationEnabled.value = value;
    await _preferences.setReminderVibrationEnabled(value);
    await _reschedule();
  }

  Future<void> _reschedule() async {
    if (!reminderEnabled.value) return;
    await _service.scheduleDailyReminder(hour: hour.value, minute: minute.value);
  }
}
