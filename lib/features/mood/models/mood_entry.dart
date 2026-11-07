import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

/// A single mood log entry.
///
/// Stored locally in Hive (keyed by [localId]) and remotely in Firestore
/// (document id [id]). [id] stays `null` until the entry has been synced,
/// which is how pending uploads are detected.
class MoodEntry {
  final String localId;
  final DateTime timestamp;
  final int moodLevel;
  final String? note;
  final String? id; // Firestore document ID
  final String? userId; // User who created this entry
  final String? title; // Optional journal title
  final List<String> tags;

  MoodEntry({
    String? localId,
    required this.timestamp,
    required this.moodLevel,
    this.note,
    this.id,
    this.userId,
    this.title,
    this.tags = const <String>[],
  }) : localId = localId ?? const Uuid().v4();

  Map<String, dynamic> toFirestore() {
    return {
      'timestamp': Timestamp.fromDate(timestamp),
      'moodLevel': moodLevel,
      'note': note,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
      if (title != null) 'title': title,
      if (tags.isNotEmpty) 'tags': tags,
    };
  }

  factory MoodEntry.fromFirestore(Map<String, dynamic> data, String docId) {
    return MoodEntry(
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      moodLevel: data['moodLevel'] as int,
      note: data['note'] as String?,
      id: docId,
      userId: data['userId'] as String?,
      title: data['title'] as String?,
      tags: (data['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const <String>[],
    );
  }

  static const Object _unset = Object();

  MoodEntry copyWith({
    String? localId,
    DateTime? timestamp,
    int? moodLevel,
    Object? note = _unset,
    Object? id = _unset,
    Object? userId = _unset,
    Object? title = _unset,
    Object? tags = _unset,
  }) {
    return MoodEntry(
      localId: localId ?? this.localId,
      timestamp: timestamp ?? this.timestamp,
      moodLevel: moodLevel ?? this.moodLevel,
      note: identical(note, _unset) ? this.note : note as String?,
      id: identical(id, _unset) ? this.id : id as String?,
      userId: identical(userId, _unset) ? this.userId : userId as String?,
      title: identical(title, _unset) ? this.title : title as String?,
      tags: identical(tags, _unset) ? this.tags : tags as List<String>,
    );
  }
}

/// Hand-written Hive adapter so the model doesn't need code generation.
class MoodEntryAdapter extends TypeAdapter<MoodEntry> {
  @override
  final int typeId = 1;

  static const int _fieldCount = 8;

  @override
  MoodEntry read(BinaryReader reader) {
    final fields = <int, dynamic>{};
    final count = reader.readByte();
    for (var i = 0; i < count; i++) {
      fields[reader.readByte()] = reader.read();
    }
    // Null-tolerant: old or partially-written frames may miss fields.
    final rawTimestamp = fields[1];
    final timestamp = switch (rawTimestamp) {
      final int ms => DateTime.fromMillisecondsSinceEpoch(ms),
      final DateTime dt => dt,
      _ => DateTime.now(),
    };
    final rawMood = fields[2];
    final moodLevel = switch (rawMood) {
      final int v => v.clamp(0, 5),
      final num n => n.toInt().clamp(0, 5),
      _ => 3,
    };
    final rawTags = fields[7];
    final tags = switch (rawTags) {
      final List<dynamic> list => list.map((e) => e.toString()).toList(),
      _ => const <String>[],
    };
    return MoodEntry(
      localId: fields[0] as String? ?? const Uuid().v4(),
      timestamp: timestamp,
      moodLevel: moodLevel,
      note: fields[3] as String?,
      id: fields[4] as String?,
      userId: fields[5] as String?,
      title: fields[6] as String?,
      tags: tags,
    );
  }

  @override
  void write(BinaryWriter writer, MoodEntry obj) {
    writer
      ..writeByte(_fieldCount)
      ..writeByte(0)
      ..write(obj.localId)
      ..writeByte(1)
      ..write(obj.timestamp.millisecondsSinceEpoch)
      ..writeByte(2)
      ..write(obj.moodLevel)
      ..writeByte(3)
      ..write(obj.note)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.userId)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
