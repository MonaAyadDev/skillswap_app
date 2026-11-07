import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillswap/core/models/request_model.dart';

class RequestsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  final StreamController<List<RequestModel>> _requestsController =
      StreamController<List<RequestModel>>.broadcast();

  // In-memory cache for instant responsiveness and offline/demo support
  final List<RequestModel> _localRequests = [
    RequestModel(
      id: 'req_1',
      fromUserId: 'alex-morgan',
      toUserId: 'current_user',
      fromUserName: 'Alex Morgan',
      toUserName: 'You',
      skillToTeach: 'UI/UX Design & Figma',
      skillToLearn: 'Flutter Development',
      message:
          'Hey! I saw your Flutter portfolio. Would love to swap UI/UX coaching for mobile app development mentorship!',
      status: RequestStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    RequestModel(
      id: 'req_2',
      fromUserId: 'jordan-lee',
      toUserId: 'current_user',
      fromUserName: 'Jordan Lee',
      toUserName: 'You',
      skillToTeach: 'JavaScript & React',
      skillToLearn: 'UI/UX Design',
      message:
          'Hi there! I am building web tools and need help polishing the UX. Can teach modern React in return.',
      status: RequestStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    RequestModel(
      id: 'req_3',
      fromUserId: 'current_user',
      toUserId: 'sam-rivera',
      fromUserName: 'You',
      toUserName: 'Sam Rivera',
      skillToTeach: 'Mobile UI Design',
      skillToLearn: 'Photography & Lighting',
      message:
          'Hello Sam! Interested in learning photography basics for product shots.',
      status: RequestStatus.accepted,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    RequestModel(
      id: 'req_4',
      fromUserId: 'taylor-kim',
      toUserId: 'current_user',
      fromUserName: 'Taylor Kim',
      toUserName: 'You',
      skillToTeach: 'Python & Data Analysis',
      skillToLearn: 'UI Prototyping',
      message: 'Great exchange completed last week! Thank you for the tips.',
      status: RequestStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  RequestsRepository(this._firestore, this._auth) {
    _emitLocal();
  }

  void _emitLocal() {
    _requestsController.add(List.unmodifiable(_localRequests));
  }

  Stream<List<RequestModel>> getRequests() {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null && uid.isNotEmpty) {
        return _firestore
            .collection('requests')
            .where(Filter.or(
              Filter('toUserId', isEqualTo: uid),
              Filter('fromUserId', isEqualTo: uid),
            ))
            .snapshots()
            .map((snapshot) {
              if (snapshot.docs.isEmpty) {
                return _localRequests;
              }
              final list = snapshot.docs
                  .map((doc) => RequestModel.fromMap(doc.data(), doc.id))
                  .toList();
              list.sort((a, b) => (b.createdAt ?? DateTime.now())
                  .compareTo(a.createdAt ?? DateTime.now()));
              return list;
            })
            .handleError((_) => _localRequests);
      }
    } catch (_) {}
    return _requestsController.stream;
  }

  Future<void> sendRequest({
    required String toUserId,
    required String toUserName,
    required String skillToLearn,
    required String skillToTeach,
    required String message,
  }) async {
    final currentUid = _auth.currentUser?.uid ?? 'current_user';
    final currentName = _auth.currentUser?.displayName ?? 'You';

    final newRequest = RequestModel(
      id: 'req_${DateTime.now().millisecondsSinceEpoch}',
      fromUserId: currentUid,
      toUserId: toUserId,
      fromUserName: currentName,
      toUserName: toUserName,
      skillToLearn: skillToLearn,
      skillToTeach: skillToTeach,
      message: message,
      status: RequestStatus.pending,
      createdAt: DateTime.now(),
    );

    _localRequests.insert(0, newRequest);
    _emitLocal();

    try {
      if (_auth.currentUser != null) {
        await _firestore.collection('requests').doc(newRequest.id).set(newRequest.toMap());
      }
    } catch (_) {}
  }

  Future<void> updateRequestStatus(String requestId, String status) async {
    final index = _localRequests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _localRequests[index] = _localRequests[index].copyWith(status: status);
      _emitLocal();
    }

    try {
      if (_auth.currentUser != null) {
        await _firestore.collection('requests').doc(requestId).update({'status': status});
      }
    } catch (_) {}
  }
}
