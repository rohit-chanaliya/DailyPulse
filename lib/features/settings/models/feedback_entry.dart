import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

/// One submitted feedback, queued locally until Firestore accepts it.
class FeedbackEntry {
  FeedbackEntry({
    String? id,
    required this.userId,
    required this.tags,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  final String id;
  final String userId;
  final List<String> tags;
  final DateTime createdAt;

  Map<String, dynamic> toLocal() => {
    'id': id,
    'userId': userId,
    'tags': tags,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };

  factory FeedbackEntry.fromLocal(Map<String, dynamic> map) {
    return FeedbackEntry(
      id: map['id'] as String,
      userId: map['userId'] as String,
      tags: List<String>.from(map['tags'] as List),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'userId': userId,
    'tags': tags,
    'createdAt': FieldValue.serverTimestamp(),
  };
}
