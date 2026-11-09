import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

import 'package:dailypulse/core/services/app_preferences.dart';

void main() {
  late Directory dir;
  late Box<dynamic> box;
  late AppPreferences preferences;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('dailypulse_prefs_test');
    Hive.init(dir.path);
    box = await Hive.openBox<dynamic>(AppPreferences.boxName);
    preferences = AppPreferences(box);
  });

  tearDown(() async {
    await box.close();
    await dir.delete(recursive: true);
  });

  test('AppPreferences reminder settings default and persist', () async {
    // Defaults
    expect(preferences.isReminderEnabled, isFalse);
    expect(preferences.reminderHour, 20);
    expect(preferences.reminderMinute, 0);

    // Update
    await preferences.setReminderEnabled(true);
    await preferences.setReminderHour(21);
    await preferences.setReminderMinute(30);

    expect(preferences.isReminderEnabled, isTrue);
    expect(preferences.reminderHour, 21);
    expect(preferences.reminderMinute, 30);
  });

  test('invalid stored values fall back instead of throwing', () async {
    await box.put('reminder_enabled', 'yes');
    await box.put('reminder_hour', 7.5);
    await box.put('reminder_minute', null);
    await box.put('has_seen_onboarding', 1);
    await box.put('pending_feedback', 'not-a-list');
    await box.put('profile_image_user-1', 42);

    expect(preferences.isReminderEnabled, isFalse);
    expect(preferences.reminderHour, 20);
    expect(preferences.reminderMinute, 0);
    expect(preferences.hasSeenOnboarding, isFalse);
    expect(preferences.pendingFeedback, isEmpty);
    expect(preferences.getProfileImagePath('user-1'), isNull);
  });

  test('pending feedback skips entries that are not maps', () async {
    await box.put('pending_feedback', [
      {
        'id': 'a',
        'userId': 'u',
        'tags': ['bug'],
        'createdAt': 1,
      },
      'broken',
    ]);

    final pending = preferences.pendingFeedback;

    expect(pending, hasLength(1));
    expect(pending.single['id'], 'a');
  });
}
