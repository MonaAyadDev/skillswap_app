import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RequestStatus {
  RequestStatus._();
  static const pending = 'pending';
  static const accepted = 'accepted';
  static const rejected = 'rejected';
  static const completed = 'completed';
}

class RequestModel extends Equatable {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String fromUserName;
  final String toUserName;
  final String skillToLearn;
  final String skillToTeach;
  final String message;
  final String status;
  final DateTime? createdAt;

  const RequestModel({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    this.fromUserName = '',
    this.toUserName = '',
    required this.skillToLearn,
    required this.skillToTeach,
    this.message = '',
    this.status = RequestStatus.pending,
    this.createdAt,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map, String id) {
    return RequestModel(
      id: id,
      fromUserId: map['fromUserId'] ?? '',
      toUserId: map['toUserId'] ?? '',
      fromUserName: map['fromUserName'] ?? '',
      toUserName: map['toUserName'] ?? '',
      skillToLearn: map['skillToLearn'] ?? '',
      skillToTeach: map['skillToTeach'] ?? '',
      message: map['message'] ?? '',
      status: map['status'] ?? RequestStatus.pending,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'fromUserId': fromUserId,
        'toUserId': toUserId,
        'fromUserName': fromUserName,
        'toUserName': toUserName,
        'skillToLearn': skillToLearn,
        'skillToTeach': skillToTeach,
        'message': message,
        'status': status,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      };

  RequestModel copyWith({
    String? id,
    String? fromUserId,
    String? toUserId,
    String? fromUserName,
    String? toUserName,
    String? skillToLearn,
    String? skillToTeach,
    String? message,
    String? status,
    DateTime? createdAt,
  }) {
    return RequestModel(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      fromUserName: fromUserName ?? this.fromUserName,
      toUserName: toUserName ?? this.toUserName,
      skillToLearn: skillToLearn ?? this.skillToLearn,
      skillToTeach: skillToTeach ?? this.skillToTeach,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fromUserId,
        toUserId,
        fromUserName,
        toUserName,
        skillToLearn,
        skillToTeach,
        message,
        status,
        createdAt,
      ];
}
