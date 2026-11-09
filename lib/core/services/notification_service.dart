import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:inject_annotation/inject_annotation.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:dailypulse/core/services/app_preferences.dart';
import 'package:dailypulse/core/utils/app_logger.dart';

/// Handles offline local notification scheduling for daily mood tracking reminders.
@singleton
class NotificationService {
  @inject
  NotificationService(this._preferences);

  final AppPreferences _preferences;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int dailyReminderId = 1001;
  static const String channelId = 'daily_mood_reminders';
  static const String channelName = 'Daily Mood Reminders';
  static const String channelDesc =
      'Gentle daily reminders to track your emotions';

  Future<void> init() async {
    try {
      tz.initializeTimeZones();
      await _setLocalTimezone();

      const androidSettings = AndroidInitializationSettings('ic_notification');
      const initSettings = InitializationSettings(android: androidSettings);

      await _plugin.initialize(settings: initSettings);

      if (_preferences.isReminderEnabled) {
        await scheduleDailyReminder(
          hour: _preferences.reminderHour,
          minute: _preferences.reminderMinute,
        );
      }
    } catch (e, st) {
      appLogger.w('NotificationService init error', error: e, stackTrace: st);
    }
  }

  /// `tz.local` defaults to UTC; point it at the device zone so the daily
  /// reminder fires at the user's local time.
  Future<void> _setLocalTimezone() async {
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (e, st) {
      appLogger.w(
        'Could not read device timezone, reminders use UTC',
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await android?.requestNotificationsPermission();
      return granted ?? false;
    }
    return true;
  }

  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    try {
      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      final playSound = _preferences.isReminderSoundEnabled;
      final vibrate = _preferences.isReminderVibrationEnabled;

      // Android fixes sound/vibration per channel, so each combo gets its own.
      final androidDetails = AndroidNotificationDetails(
        '${channelId}_s${playSound ? 1 : 0}_v${vibrate ? 1 : 0}',
        channelName,
        channelDescription: channelDesc,
        importance: Importance.high,
        priority: Priority.high,
        playSound: playSound,
        enableVibration: vibrate,
      );

      final details = NotificationDetails(android: androidDetails);

      await _plugin.zonedSchedule(
        id: dailyReminderId,
        title: 'How are you feeling today?',
        body: 'Take a moment to check in with yourself and log your mood.',
        scheduledDate: scheduledDate,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      await _preferences.setReminderEnabled(true);
      await _preferences.setReminderHour(hour);
      await _preferences.setReminderMinute(minute);
      appLogger.i('Scheduled daily reminder for $hour:$minute');
    } catch (e, st) {
      appLogger.e(
        'Failed to schedule daily reminder',
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> cancelDailyReminder() async {
    try {
      await _plugin.cancel(id: dailyReminderId);
      await _preferences.setReminderEnabled(false);
      appLogger.i('Cancelled daily reminder');
    } catch (e, st) {
      appLogger.e(
        'Failed to cancel daily reminder',
        error: e,
        stackTrace: st,
      );
    }
  }
}
