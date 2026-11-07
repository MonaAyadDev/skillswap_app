import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillswap/core/models/message_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;

  final Map<String, List<MessageModel>> _localMessages = {
    'chat_alex-morgan': [
      MessageModel(
        id: 'm1',
        senderId: 'alex-morgan',
        text: 'Hey! Thanks for connecting. I am super excited to learn Flutter!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      MessageModel(
        id: 'm2',
        senderId: 'current_user',
        text: 'Hi Alex! Excited to exchange with you. Your Figma systems are incredible.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      MessageModel(
        id: 'm3',
        senderId: 'alex-morgan',
        text: 'Awesome! Shall we schedule our first 1-hour session this Thursday at 6 PM?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    ],
    'match_1': [
      MessageModel(
        id: 'm10',
        senderId: 'alex-morgan',
        text: 'Looking forward to our weekly swap session!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ],
    'match_2': [
      MessageModel(
        id: 'm20',
        senderId: 'jordan-lee',
        text: 'Awesome progress on the API integration.',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  };

  final Map<String, StreamController<List<MessageModel>>> _controllers = {};

  ChatRepository(this._firestore);

  StreamController<List<MessageModel>> _getController(String matchId) {
    if (!_controllers.containsKey(matchId)) {
      _controllers[matchId] = StreamController<List<MessageModel>>.broadcast();
    }
    return _controllers[matchId]!;
  }

  Stream<List<MessageModel>> getMessages(String matchId) {
    try {
      return _firestore
          .collection('matches')
          .doc(matchId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            if (snapshot.docs.isEmpty) {
              final fallback = _localMessages[matchId] ?? [];
              fallback.sort((a, b) => (b.createdAt ?? DateTime.now())
                  .compareTo(a.createdAt ?? DateTime.now()));
              return fallback;
            }
            return snapshot.docs
                .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
                .toList();
          })
          .handleError((_) {
            final fallback = _localMessages[matchId] ?? [];
            fallback.sort((a, b) => (b.createdAt ?? DateTime.now())
                .compareTo(a.createdAt ?? DateTime.now()));
            return fallback;
          });
    } catch (_) {
      final ctrl = _getController(matchId);
      final list = _localMessages[matchId] ?? [];
      list.sort((a, b) => (b.createdAt ?? DateTime.now())
          .compareTo(a.createdAt ?? DateTime.now()));
      Timer.run(() => ctrl.add(List.unmodifiable(list)));
      return ctrl.stream;
    }
  }

  Future<void> sendMessage({
    required String matchId,
    required String senderId,
    required String text,
  }) async {
    final newMsg = MessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      text: text,
      createdAt: DateTime.now(),
    );

    if (!_localMessages.containsKey(matchId)) {
      _localMessages[matchId] = [];
    }
    _localMessages[matchId]!.insert(0, newMsg);

    final ctrl = _getController(matchId);
    ctrl.add(List.unmodifiable(_localMessages[matchId]!));

    try {
      final messageData = {
        'senderId': senderId,
        'text': text,
        'type': 'text',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('matches')
          .doc(matchId)
          .collection('messages')
          .add(messageData);

      await _firestore.collection('matches').doc(matchId).update({
        'lastMessage': text,
        'lastMessageAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }
}
