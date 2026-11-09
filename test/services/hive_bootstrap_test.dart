import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

import 'package:dailypulse/core/services/app_preferences.dart';
import 'package:dailypulse/core/services/hive_bootstrap.dart';
import 'package:dailypulse/features/mood/datasource/hive_service.dart';
import 'package:dailypulse/features/mood/models/mood_entry.dart';

void main() {
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('dailypulse_bootstrap_test');
  });

  tearDown(() async {
    await Hive.close();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  });

  test('quarantines a corrupt box and opens a fresh one', () async {
    // A small declared frame length (16) with invalid body bytes trips Hive's
    // unrecoverable first-frame check (`header <= writeOffset`).
    final corruptFile = File('${dir.path}/${AppPreferences.boxName}.hive');
    final bytes = <int>[16, 0, 0, 0, ...List<int>.filled(60, 0xFF)];
    await corruptFile.writeAsBytes(bytes);

    await HiveBootstrap.init(storagePath: dir.path);

    expect(Hive.isBoxOpen(HiveService.boxName), isTrue);
    expect(Hive.isBoxOpen(AppPreferences.boxName), isTrue);

    final prefs = AppPreferences(Hive.box<dynamic>(AppPreferences.boxName));
    expect(prefs.isReminderEnabled, isFalse);

    final files = dir.listSync().map((e) => e.path).toList();
    expect(
      files.any(
        (path) => path.contains('${AppPreferences.boxName}.hive.corrupt-'),
      ),
      isTrue,
      reason: 'The broken file should be renamed rather than deleted',
    );
  });

  test('opens clean boxes and round-trips a mood entry', () async {
    await HiveBootstrap.init(storagePath: dir.path);

    final moodBox = Hive.box<MoodEntry>(HiveService.boxName);
    final entry = MoodEntry(
      localId: 'local-1',
      userId: 'user-1',
      moodLevel: 4,
      timestamp: DateTime(2026, 11, 10),
    );
    await moodBox.put(entry.localId, entry);

    expect(moodBox.get('local-1')?.moodLevel, 4);
  });
}
