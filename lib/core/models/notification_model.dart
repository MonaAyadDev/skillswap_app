import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String userId; // صاحب الإشعار
  final String type; // request / accepted / message / rating
  final String text;
  final String relatedId; // رقم الطلب أو الـ Match المرتبط
  final bool isRead;
  final DateTime? createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.text,
    this.relatedId = '',
    this.isRead = false,
    this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      userId: map['userId'] ?? '',
      type: map['type'] ?? '',
      text: map['text'] ?? '',
      relatedId: map['relatedId'] ?? '',
      isRead: map['isRead'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'type': type,
        'text': text,
        'relatedId': relatedId,
        'isRead': isRead,
      };

  @override
  List<Object?> get props =>
      [id, userId, type, text, relatedId, isRead, createdAt];
}