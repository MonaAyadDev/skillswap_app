import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MatchModel extends Equatable {
  final String id;
  final List<String> userIds; // الاتنين المشتركين في الـ Match
  final List<String> skillsExchanged; // مثلاً ['Flutter', 'Photoshop']
  final String lastMessage;
  final DateTime? lastMessageAt;
  final DateTime? createdAt;

  const MatchModel({
    required this.id,
    required this.userIds,
    this.skillsExchanged = const [],
    this.lastMessage = '',
    this.lastMessageAt,
    this.createdAt,
  });

  factory MatchModel.fromMap(Map<String, dynamic> map, String id) {
    return MatchModel(
      id: id,
      userIds: List<String>.from(map['userIds'] ?? []),
      skillsExchanged: List<String>.from(map['skillsExchanged'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageAt: (map['lastMessageAt'] as Timestamp?)?.toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'userIds': userIds,
        'skillsExchanged': skillsExchanged,
        'lastMessage': lastMessage,
      };

  @override
  List<Object?> get props =>
      [id, userIds, skillsExchanged, lastMessage, lastMessageAt, createdAt];
}
