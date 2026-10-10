import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String name;
  final String bio;
  final String country;
  final String photoUrl;
  final List<String> teachSkills;
  final List<String> learnSkills;
  final double ratingAvg;
  final int ratingCount;
  final DateTime? createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    this.bio = '',
    this.country = '',
    this.photoUrl = '',
    this.teachSkills = const [],
    this.learnSkills = const [],
    this.ratingAvg = 0,
    this.ratingCount = 0,
    this.createdAt,
  });

  /// [id] هو رقم المستند (uid) وبيجي من Firestore منفصل عن الـ Map
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      name: map['name'] ?? '',
      bio: map['bio'] ?? '',
      country: map['country'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      teachSkills: List<String>.from(map['teachSkills'] ?? []),
      learnSkills: List<String>.from(map['learnSkills'] ?? []),
      ratingAvg: (map['ratingAvg'] ?? 0).toDouble(),
      ratingCount: map['ratingCount'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// مفيهاش uid ولا createdAt:
  /// الـ uid هو اسم المستند، والـ createdAt بيتحط وقت الإنشاء بـ FieldValue.serverTimestamp()
  Map<String, dynamic> toMap() => {
        'name': name,
        'bio': bio,
        'country': country,
        'photoUrl': photoUrl,
        'teachSkills': teachSkills,
        'learnSkills': learnSkills,
        'ratingAvg': ratingAvg,
        'ratingCount': ratingCount,
      };

  @override
  List<Object?> get props => [
        uid,
        name,
        bio,
        country,
        photoUrl,
        teachSkills,
        learnSkills,
        ratingAvg,
        ratingCount,
        createdAt,
      ];
}