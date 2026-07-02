import 'package:objectbox/objectbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@Entity()
class MoodEntry {
  @Id()
  int obxId;

  @Property(type: PropertyType.date)
  final DateTime timestamp;
  final int moodLevel;
  final String? note;
  final String? id; // Firestore document ID
  final String? userId; // User who created this entry

  MoodEntry({
    this.obxId = 0,
    required this.timestamp,
    required this.moodLevel,
    this.note,
    this.id,
    this.userId,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'timestamp': Timestamp.fromDate(timestamp),
      'moodLevel': moodLevel,
      'note': note,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory MoodEntry.fromFirestore(Map<String, dynamic> data, String docId) {
    return MoodEntry(
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      moodLevel: data['moodLevel'] as int,
      note: data['note'] as String?,
      id: docId,
      userId: data['userId'] as String?,
    );
  }

  MoodEntry copyWith({
    int? obxId,
    DateTime? timestamp,
    int? moodLevel,
    String? note,
    String? id,
    String? userId,
  }) {
    return MoodEntry(
      obxId: obxId ?? this.obxId,
      timestamp: timestamp ?? this.timestamp,
      moodLevel: moodLevel ?? this.moodLevel,
      note: note ?? this.note,
      id: id ?? this.id,
      userId: userId ?? this.userId,
    );
  }
}
