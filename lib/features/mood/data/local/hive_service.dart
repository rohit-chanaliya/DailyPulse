import 'package:hive_ce_flutter/hive_flutter.dart';

import '../models/mood_entry.dart';

/// Owns the Hive lifecycle and exposes the mood entries box.
class HiveService {
  static const String boxName = 'mood_entries';
  static const String _directory = 'dailypulse';

  static late final Box<MoodEntry> moodBox;

  HiveService._();

  static Future<void> init() async {
    await Hive.initFlutter(_directory);

    if (!Hive.isAdapterRegistered(MoodEntryAdapter().typeId)) {
      Hive.registerAdapter(MoodEntryAdapter());
    }

    moodBox = await Hive.openBox<MoodEntry>(boxName);
  }

  /// Emits the current entries whenever the box changes.
  static Stream<List<MoodEntry>> watchAll() {
    return moodBox.watch().map((_) => _sorted(moodBox.values.toList()));
  }

  /// All entries, newest first.
  static List<MoodEntry> getAll() => _sorted(moodBox.values.toList());

  static List<MoodEntry> _sorted(List<MoodEntry> entries) {
    return entries..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  static Future<void> put(MoodEntry entry) => moodBox.put(entry.localId, entry);

  static Future<void> putAll(Iterable<MoodEntry> entries) {
    return moodBox.putAll({for (final e in entries) e.localId: e});
  }

  static Future<void> clear() => moodBox.clear();
}
