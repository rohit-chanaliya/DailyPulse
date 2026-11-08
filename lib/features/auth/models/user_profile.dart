import 'package:cloud_firestore/cloud_firestore.dart';

/// Representation of a registered user's profile stored in Cloud Firestore.
class UserProfile {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final DateTime? dateOfBirth;
  final String location;

  /// Id of the preset avatar picked in Personal Information, or empty.
  final String avatarId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    this.dateOfBirth,
    this.location = '',
    this.avatarId = '',
    this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  /// Whole years between [dateOfBirth] and [now], or `null` when unset.
  int? ageAt(DateTime now) {
    final dob = dateOfBirth;
    if (dob == null) return null;
    final hadBirthday =
        now.month > dob.month || (now.month == dob.month && now.day >= dob.day);
    final age = now.year - dob.year - (hadBirthday ? 0 : 1);
    return age < 0 ? null : age;
  }

  UserProfile copyWith({
    String? userId,
    String? email,
    String? firstName,
    String? lastName,
    String? gender,
    DateTime? dateOfBirth,
    String? location,
    String? avatarId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      location: location ?? this.location,
      avatarId: avatarId ?? this.avatarId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'name': fullName,
      'gender': gender,
      if (dateOfBirth != null) 'dateOfBirth': Timestamp.fromDate(dateOfBirth!),
      'location': location,
      'avatarId': avatarId,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory UserProfile.fromFirestore(Map<String, dynamic> data, String id) {
    return UserProfile(
      userId: id,
      email: data['email'] as String? ?? '',
      firstName: data['firstName'] as String? ?? '',
      lastName: data['lastName'] as String? ?? '',
      gender: data['gender'] as String? ?? '',
      dateOfBirth: (data['dateOfBirth'] as Timestamp?)?.toDate(),
      location: data['location'] as String? ?? '',
      avatarId: data['avatarId'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
