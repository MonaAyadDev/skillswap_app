import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillswap/core/models/notification_model.dart';

class NotificationsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  final StreamController<List<NotificationModel>> _notificationsController =
      StreamController<List<NotificationModel>>.broadcast();

  final List<NotificationModel> _mockNotifications = [
    NotificationModel(
      id: 'notif_1',
      userId: 'current_user',
      type: 'request',
      title: 'New Swap Request!',
      text: 'Alex Morgan sent you a swap request: Figma UI Design for Flutter.',
      relatedId: 'req_1',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    NotificationModel(
      id: 'notif_2',
      userId: 'current_user',
      type: 'request',
      title: 'Request Accepted 🎉',
      text: 'Sam Rivera accepted your photography exchange request! Say hi in chat.',
      relatedId: 'req_3',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'notif_3',
      userId: 'current_user',
      type: 'message',
      title: 'New Message',
      text: 'Jordan Lee: "Awesome progress on the API integration."',
      relatedId: 'match_2',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NotificationModel(
      id: 'notif_4',
      userId: 'current_user',
      type: 'review',
      title: '5-Star Review Received ⭐',
      text: 'Taylor Kim gave you 5 stars: "Patient mentor and fantastic explanations!"',
      relatedId: 'req_4',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationModel(
      id: 'notif_5',
      userId: 'current_user',
      type: 'match',
      title: 'High Affinity Match Found',
      text: 'You have a 98% skill match with Alex Morgan!',
      relatedId: 'match_1',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  NotificationsRepository(this._firestore, this._auth) {
    _emit();
  }

  void _emit() {
    _notificationsController.add(List.unmodifiable(_mockNotifications));
  }

  Stream<List<NotificationModel>> getNotifications() {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null && uid.isNotEmpty) {
        return _firestore
            .collection('notifications')
            .where('userId', isEqualTo: uid)
            .orderBy('createdAt', descending: true)
            .snapshots()
            .map((snapshot) {
              if (snapshot.docs.isEmpty) return _mockNotifications;
              return snapshot.docs
                  .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
                  .toList();
            })
            .handleError((_) => _mockNotifications);
      }
    } catch (_) {}
    return _notificationsController.stream;
  }

  Future<void> markAsRead(String id) async {
    final index = _mockNotifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _mockNotifications[index] = _mockNotifications[index].copyWith(isRead: true);
      _emit();
    }
    try {
      if (_auth.currentUser != null) {
        await _firestore.collection('notifications').doc(id).update({'isRead': true});
      }
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    for (int i = 0; i < _mockNotifications.length; i++) {
      _mockNotifications[i] = _mockNotifications[i].copyWith(isRead: true);
    }
    _emit();
  }
}
