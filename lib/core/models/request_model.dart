import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// حالات الطلب (استخدميها بدل ما تكتبي النص بإيدك)
class RequestStatus {
  RequestStatus._();
  static const pending = 'pending';
  static const accepted = 'accepted';
  static const rejected = 'rejected';
}

class RequestModel extends Equatable {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String skillToLearn;
  final String skillToTeach;
  final String message;
  final String status;
  final DateTime? createdAt;

  const RequestModel({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
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
        'skillToLearn': skillToLearn,
        'skillToTeach': skillToTeach,
        'message': message,
        'status': status,
      };

  @override
  List<Object?> get props => [
        id,
        fromUserId,
        toUserId,
        skillToLearn,
        skillToTeach,
        message,
        status,
        createdAt,
      ];
}