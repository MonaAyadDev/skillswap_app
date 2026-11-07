import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String userId;
  final String type; // 'request', 'message', 'match', 'review'
  final String title;
  final String text;
  final String relatedId;
  final bool isRead;
  final DateTime? createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    this.title = '',
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
      title: map['title'] ?? '',
      text: map['text'] ?? '',
      relatedId: map['relatedId'] ?? '',
      isRead: map['isRead'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'type': type,
        'title': title,
        'text': text,
        'relatedId': relatedId,
        'isRead': isRead,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      };

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    String? text,
    String? relatedId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      text: text ?? this.text,
      relatedId: relatedId ?? this.relatedId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        title,
        text,
        relatedId,
        isRead,
        createdAt,
      ];
}
