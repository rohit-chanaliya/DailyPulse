import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inject_annotation/inject_annotation.dart';

import '../models/mood_entry.dart';
import 'package:dailypulse/core/utils/app_logger.dart';

/// Firestore access for mood entries.
@singleton
class FirestoreService {
  @inject
  FirestoreService(this._firestore);

  final FirebaseFirestore _firestore;
  static const String _moodsCollection = 'moods';
  static const String _usersCollection = 'users';
  static const String _preferencesCollection = 'preferences';

  /// Firestore caps a single write batch at 500 operations.
  static const int _deleteBatchSize = 400;

  Future<String?> addMoodEntry(MoodEntry entry) async {
    try {
      // The local id doubles as the document id, which makes a sync retry
      // idempotent: if the write commits but the response is lost, the retry
      // overwrites the same document instead of creating a duplicate.
      final docRef = _firestore
          .collection(_moodsCollection)
          .doc(entry.localId);
      await docRef.set(entry.toFirestore());
      appLogger.d('Added mood entry to Firestore: ${docRef.id}');
      return docRef.id;
    } catch (e, stackTrace) {
      appLogger.e(
        'Error adding mood entry to Firestore',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Fetch all mood entries for a specific user
  Future<List<MoodEntry>> fetchMoodEntries(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_moodsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      appLogger.i('Fetched ${querySnapshot.docs.length} entries from Firebase');
      return querySnapshot.docs
          .map((doc) => MoodEntry.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      appLogger.w('Error fetching from Firebase with orderBy', error: e);
      // If orderBy fails (missing index), try without orderBy
      try {
        final querySnapshot = await _firestore
            .collection(_moodsCollection)
            .where('userId', isEqualTo: userId)
            .get();

        appLogger.i(
          'Fetched ${querySnapshot.docs.length} entries (without orderBy)',
        );
        final entries = querySnapshot.docs
            .map((doc) => MoodEntry.fromFirestore(doc.data(), doc.id))
            .toList();
        // Sort locally
        entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        return entries;
      } catch (e2, stackTrace2) {
        appLogger.e(
          'Error fetching without orderBy',
          error: e2,
          stackTrace: stackTrace2,
        );
        // Throw so callers can distinguish failure from an empty list.
        // Returning [] here would let a merge wipe local (including pending)
        // entries, so the repository must fall back to local data instead.
        rethrow;
      }
    }
  }

  /// Deletes every mood entry owned by [userId].
  ///
  /// Deletes are chunked because a Firestore batch is limited to 500 writes.
  Future<void> deleteMoodEntries(String userId) async {
    while (true) {
      final snapshot = await _firestore
          .collection(_moodsCollection)
          .where('userId', isEqualTo: userId)
          .limit(_deleteBatchSize)
          .get();

      if (snapshot.docs.isEmpty) return;

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }

  /// Deletes a user-scoped document (profile / preferences) when it exists.
  Future<void> deleteUserDocument(String collection, String userId) async {
    final doc = await _firestore.collection(collection).doc(userId).get();
    if (!doc.exists) return;
    await doc.reference.delete();
  }

  /// Wipes every remote trace of [userId].
  ///
  /// Must run while the user is still signed in — the security rules only
  /// allow owners to delete their own documents.
  Future<void> deleteAccountData(String userId) async {
    await deleteMoodEntries(userId);
    await deleteUserDocument(_usersCollection, userId);
    await deleteUserDocument(_preferencesCollection, userId);
  }
}
