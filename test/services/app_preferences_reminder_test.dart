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
}
