import 'dart:io';

import 'package:dailypulse/features/settings/models/feedback_entry.dart';
import 'package:dailypulse/features/mood/datasource/firestore_service.dart';
import 'package:dailypulse/features/mood/datasource/hive_service.dart';
import 'package:dailypulse/features/mood/models/mood_entry.dart';
import 'package:dailypulse/features/mood/repository/mood_repository.dart';
import 'package:dailypulse/features/mood/services/sync_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

/// The fetch/merge path never touches sync, so a no-op implementation is enough.
class _FakeSyncService implements SyncService {
  @override
  void startBackgroundSync() {}

  @override
  void stopBackgroundSync() {}

  @override
  Future<void> syncPendingEntries() async {}

  @override
  Future<bool> forceSyncNow() async => true;

  @override
  bool hasPendingSyncs() => false;

  @override
  int getPendingSyncCount() => 0;
}

class _FakeFirestoreService implements FirestoreService {
  _FakeFirestoreService({this.remote = const [], this.failure});

  final List<MoodEntry> remote;
  final Object? failure;

  @override
  Future<List<MoodEntry>> fetchMoodEntries(String userId) async {
    final error = failure;
    if (error != null) throw error;
    return remote;
  }

  @override
  Future<String?> addMoodEntry(MoodEntry entry) async => 'doc-${entry.localId}';

  @override
  Future<bool> addFeedback(FeedbackEntry entry) async => true;

  @override
  Future<void> deleteMoodEntries(String userId) async {}

  @override
  Future<void> deleteUserDocument(String collection, String userId) async {}

  @override
  Future<void> deleteAccountData(String userId) async {}
}

void main() {
  late Directory dir;
  late Box<MoodEntry> box;
  late HiveService hive;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('dailypulse_repo_test');
    Hive.init(dir.path);
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MoodEntryAdapter());
    }
    box = await Hive.openBox<MoodEntry>('mood_entries');
    hive = HiveService(box);
  });

  tearDown(() async {
    await Hive.close();
    await dir.delete(recursive: true);
  });

  MoodEntry entry({
    required String localId,
    required String userId,
    String? id,
    int level = 3,
    DateTime? at,
  }) {
    return MoodEntry(
      localId: localId,
      userId: userId,
      id: id,
      moodLevel: level,
      timestamp: at ?? DateTime(2026, 11, 1),
    );
  }

  test('merge keeps pending entries and does not duplicate synced ones', () async {
    await hive.put(
      entry(localId: 'pending-1', userId: 'u1', at: DateTime(2026, 11, 2)),
    );
    await hive.put(
      entry(
        localId: 'local-1',
        userId: 'u1',
        id: 'doc-1',
        at: DateTime(2026, 11, 1),
      ),
    );

    final repository = MoodRepository(
      hive,
      _FakeSyncService(),
      _FakeFirestoreService(
        remote: [
          entry(
            localId: 'remote-temp',
            userId: 'u1',
            id: 'doc-1',
            at: DateTime(2026, 11, 1),
          ),
          entry(
            localId: 'remote-temp-2',
            userId: 'u1',
            id: 'doc-2',
            at: DateTime(2026, 11, 3),
          ),
        ],
      ),
    );

    final result = await repository.fetchAndSyncFromFirebase('u1');

    expect(
      result.where((e) => e.id == null && e.localId == 'pending-1').length,
      1,
    );
    expect(result.where((e) => e.id == 'doc-1').length, 1);
    expect(result.any((e) => e.id == 'doc-2'), isTrue);
    expect(result.length, 3);
  });

  test('remote deletes only remove synced entries of the same user', () async {
    await hive.put(
      entry(localId: 'u1-synced', userId: 'u1', id: 'old-doc'),
    );
    await hive.put(entry(localId: 'u1-pending', userId: 'u1'));
    await hive.put(
      entry(localId: 'u2-synced', userId: 'u2', id: 'other-doc'),
    );

    final repository = MoodRepository(
      hive,
      _FakeSyncService(),
      _FakeFirestoreService(),
    );

    final result = await repository.fetchAndSyncFromFirebase('u1');

    expect(result.any((e) => e.id == 'old-doc'), isFalse);
    expect(result.any((e) => e.localId == 'u1-pending'), isTrue);
    expect(hive.getAllForUser('u2').single.localId, 'u2-synced');
  });

  test('a failed remote fetch keeps local entries untouched', () async {
    await hive.put(entry(localId: 'local-1', userId: 'u1'));

    final repository = MoodRepository(
      hive,
      _FakeSyncService(),
      _FakeFirestoreService(failure: StateError('offline')),
    );

    final result = await repository.fetchAndSyncFromFirebase('u1');

    expect(result.single.localId, 'local-1');
    expect(hive.getAllForUser('u1').single.localId, 'local-1');
  });
}
