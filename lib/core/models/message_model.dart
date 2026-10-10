import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String id;
  final String senderId;
  final String text;
  final String type; // 'text' دلوقتي، ولاحقًا 'image' أو 'file'
  final DateTime? createdAt;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    this.type = 'text',
    this.createdAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    return MessageModel(
      id: id,
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      type: map['type'] ?? 'text',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() =>
      {'senderId': senderId, 'text': text, 'type': type};

  @override
  List<Object?> get props => [id, senderId, text, type, createdAt];
}