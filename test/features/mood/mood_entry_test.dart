import 'dart:io';

import 'package:dailypulse/features/mood/models/mood_entry.dart';
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

  test('MoodEntry survives a Hive write/read round-trip with tags', () async {
    final box = await Hive.openBox<MoodEntry>('mood_entries_tags');
    final entry = MoodEntry(
      timestamp: DateTime(2026, 10, 22, 10, 30, 15),
      moodLevel: 4,
      note: 'Exercised today',
      tags: const ['Exercise', 'Health'],
    );

    await box.put(entry.localId, entry);

    // Reopen to test binary deserialization
    await box.close();
    final reopened = await Hive.openBox<MoodEntry>('mood_entries_tags');
    final restored = reopened.get(entry.localId);

    expect(restored, isNotNull);
    expect(restored!.tags, const ['Exercise', 'Health']);
  });

  test('toFirestore and fromFirestore round-trip tags correctly', () {
    final entry = MoodEntry(
      timestamp: DateTime(2026, 5, 1, 12, 0),
      moodLevel: 5,
      title: 'Great day',
      tags: const ['Family', 'Friends'],
    );

    final map = entry.toFirestore();
    expect(map['tags'], const ['Family', 'Friends']);

    final fromFs = MoodEntry.fromFirestore(map, 'doc-456');
    expect(fromFs.tags, const ['Family', 'Friends']);
    expect(fromFs.id, 'doc-456');
    expect(fromFs.moodLevel, 5);
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

  test('copyWith can explicitly clear nullable fields back to null', () {
    final entry = MoodEntry(
      timestamp: DateTime(2026, 1, 1),
      moodLevel: 4,
      note: 'Initial note',
      title: 'Initial title',
      id: 'doc-123',
      userId: 'user-1',
    );

    final preserved = entry.copyWith(moodLevel: 5);
    expect(preserved.note, 'Initial note');
    expect(preserved.title, 'Initial title');

    final cleared = entry.copyWith(note: null, title: null);
    expect(cleared.note, isNull);
    expect(cleared.title, isNull);
    expect(cleared.id, 'doc-123');
    expect(cleared.userId, 'user-1');
  });

  test('adapter clamps out-of-range mood levels on read', () async {
    final box = await Hive.openBox<MoodEntry>('mood_entries_clamped');

    final high = MoodEntry(timestamp: DateTime(2026, 1, 1), moodLevel: 99);
    final low = MoodEntry(timestamp: DateTime(2026, 1, 2), moodLevel: -3);

    await box.put(high.localId, high);
    await box.put(low.localId, low);

    // Hive caches values in memory; reopen to force the adapter's read path.
    await box.close();
    final reopened = await Hive.openBox<MoodEntry>('mood_entries_clamped');

    expect(reopened.get(high.localId)!.moodLevel, 5);
    expect(reopened.get(low.localId)!.moodLevel, 0);
  });
}
