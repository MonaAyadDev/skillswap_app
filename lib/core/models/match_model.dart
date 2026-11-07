import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MatchModel extends Equatable {
  final String id;
  final List<String> userIds;
  final List<String> skillsExchanged;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final DateTime? createdAt;
  final int matchPercentage;
  final String partnerName;
  final String partnerPhoto;
  final String partnerSkill;

  const MatchModel({
    required this.id,
    required this.userIds,
    this.skillsExchanged = const [],
    this.lastMessage = '',
    this.lastMessageAt,
    this.createdAt,
    this.matchPercentage = 95,
    this.partnerName = '',
    this.partnerPhoto = '',
    this.partnerSkill = '',
  });

  factory MatchModel.fromMap(Map<String, dynamic> map, String id) {
    return MatchModel(
      id: id,
      userIds: List<String>.from(map['userIds'] ?? []),
      skillsExchanged: List<String>.from(map['skillsExchanged'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageAt: (map['lastMessageAt'] as Timestamp?)?.toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      matchPercentage: map['matchPercentage'] ?? 95,
      partnerName: map['partnerName'] ?? '',
      partnerPhoto: map['partnerPhoto'] ?? '',
      partnerSkill: map['partnerSkill'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'userIds': userIds,
        'skillsExchanged': skillsExchanged,
        'lastMessage': lastMessage,
        'lastMessageAt': lastMessageAt != null ? Timestamp.fromDate(lastMessageAt!) : FieldValue.serverTimestamp(),
        'matchPercentage': matchPercentage,
        'partnerName': partnerName,
        'partnerPhoto': partnerPhoto,
        'partnerSkill': partnerSkill,
      };

  MatchModel copyWith({
    String? id,
    List<String>? userIds,
    List<String>? skillsExchanged,
    String? lastMessage,
    DateTime? lastMessageAt,
    DateTime? createdAt,
    int? matchPercentage,
    String? partnerName,
    String? partnerPhoto,
    String? partnerSkill,
  }) {
    return MatchModel(
      id: id ?? this.id,
      userIds: userIds ?? this.userIds,
      skillsExchanged: skillsExchanged ?? this.skillsExchanged,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      createdAt: createdAt ?? this.createdAt,
      matchPercentage: matchPercentage ?? this.matchPercentage,
      partnerName: partnerName ?? this.partnerName,
      partnerPhoto: partnerPhoto ?? this.partnerPhoto,
      partnerSkill: partnerSkill ?? this.partnerSkill,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userIds,
        skillsExchanged,
        lastMessage,
        lastMessageAt,
        createdAt,
        matchPercentage,
        partnerName,
        partnerPhoto,
        partnerSkill,
      ];
}
