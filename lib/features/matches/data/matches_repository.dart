import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillswap/core/models/match_model.dart';

class MatchesRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  final StreamController<List<MatchModel>> _matchesController =
      StreamController<List<MatchModel>>.broadcast();

  final List<MatchModel> _mockMatches = [
    const MatchModel(
      id: 'match_1',
      userIds: ['current_user', 'alex-morgan'],
      partnerName: 'Alex Morgan',
      partnerSkill: 'UI/UX Design & Figma',
      skillsExchanged: ['UI/UX Design', 'Flutter Development'],
      matchPercentage: 98,
      lastMessage: 'Let’s sync this Tuesday for the design review!',
    ),
    const MatchModel(
      id: 'match_2',
      userIds: ['current_user', 'jordan-lee'],
      partnerName: 'Jordan Lee',
      partnerSkill: 'Web Development & React',
      skillsExchanged: ['Frontend Dev', 'Dart / Flutter'],
      matchPercentage: 94,
      lastMessage: 'Awesome progress on the API integration.',
    ),
    const MatchModel(
      id: 'match_3',
      userIds: ['current_user', 'sam-rivera'],
      partnerName: 'Sam Rivera',
      partnerSkill: 'Photography & Lighting',
      skillsExchanged: ['Photography', 'Graphic Design'],
      matchPercentage: 90,
      lastMessage: 'Looking forward to our next weekend session.',
    ),
    const MatchModel(
      id: 'match_4',
      userIds: ['current_user', 'taylor-kim'],
      partnerName: 'Taylor Kim',
      partnerSkill: 'Python & Data Science',
      skillsExchanged: ['Data Analysis', 'Mobile UI'],
      matchPercentage: 88,
      lastMessage: 'I sent you the Jupyter notebook links.',
    ),
    const MatchModel(
      id: 'match_5',
      userIds: ['current_user', 'casey-patel'],
      partnerName: 'Casey Patel',
      partnerSkill: 'Public Speaking & Debate',
      skillsExchanged: ['Communication', 'Web Dev'],
      matchPercentage: 85,
      lastMessage: 'Ready for our mock pitch practice!',
    ),
  ];

  MatchesRepository(this._firestore, this._auth) {
    _matchesController.add(List.unmodifiable(_mockMatches));
  }

  Stream<List<MatchModel>> getMatches() {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null && uid.isNotEmpty) {
        return _firestore
            .collection('matches')
            .where('userIds', arrayContains: uid)
            .snapshots()
            .map((snapshot) {
              if (snapshot.docs.isEmpty) {
                return _mockMatches;
              }
              return snapshot.docs
                  .map((doc) => MatchModel.fromMap(doc.data(), doc.id))
                  .toList();
            })
            .handleError((_) => _mockMatches);
      }
    } catch (_) {}
    return _matchesController.stream;
  }
}
