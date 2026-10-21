import 'dart:io';

import 'package:dailypulse/features/mood/data/models/mood_entry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

void main() {
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('dailypulse_hive_test');
    Hive.init(dir.path);
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MoodEntryAdapter());
    }
  });

  tearDown(() async {
    await Hive.close();
    await dir.delete(recursive: true);
  });

  test('MoodEntry survives a Hive write/read round-trip', () async {
    final box = await Hive.openBox<MoodEntry>('mood_entries');
    final entry = MoodEntry(
      timestamp: DateTime(2026, 10, 22, 10, 30, 15),
      moodLevel: 4,
      note: 'Feeling good',
      id: 'firestore-doc',
      userId: 'user-1',
    );

    await box.put(entry.localId, entry);
    final restored = box.get(entry.localId);

    expect(restored, isNotNull);
    expect(restored!.localId, entry.localId);
    expect(restored.timestamp, entry.timestamp);
    expect(restored.moodLevel, 4);
    expect(restored.note, 'Feeling good');
    expect(restored.id, 'firestore-doc');
    expect(restored.userId, 'user-1');
  });

  test('nullable fields round-trip as null', () async {
    final box = await Hive.openBox<MoodEntry>('mood_entries_nullable');
    final entry = MoodEntry(timestamp: DateTime(2026, 1, 1), moodLevel: 2);

    await box.put(entry.localId, entry);
    final restored = box.get(entry.localId)!;

    expect(restored.note, isNull);
    expect(restored.id, isNull);
    expect(restored.userId, isNull);
    expect(restored.localId, isNotEmpty);
  });
}
