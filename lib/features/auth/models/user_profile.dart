import 'package:cloud_firestore/cloud_firestore.dart';

/// Representation of a registered user's profile stored in Cloud Firestore.
class UserProfile {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'name': fullName,
      'gender': gender,
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
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
