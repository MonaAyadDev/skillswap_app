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

  UserModel copyWith({
    String? uid,
    String? name,
    String? bio,
    String? country,
    String? photoUrl,
    List<String>? teachSkills,
    List<String>? learnSkills,
    double? ratingAvg,
    int? ratingCount,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      country: country ?? this.country,
      photoUrl: photoUrl ?? this.photoUrl,
      teachSkills: teachSkills ?? this.teachSkills,
      learnSkills: learnSkills ?? this.learnSkills,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      ratingCount: ratingCount ?? this.ratingCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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
