import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillswap/core/models/match_model.dart';
import 'package:skillswap/core/models/user_model.dart';

class MatchesRepository {
  final FirebaseFirestore db;
  final FirebaseAuth auth;

  MatchesRepository(this.db, this.auth);

  ////////////////////to get users you match with///////////////////////////
  Stream<List<MatchModel>> watchMatches() {
    final uid = auth.currentUser?.uid;

    if (uid == null) return Stream.value([]);

    return db
        .collection('matches')
        .where('userIds', arrayContains: uid)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => MatchModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  /////////////////////////////////////////////////////////////////////////
  Future<UserModel?> getUser(String id) async {
    final doc = await db.collection('users').doc(id).get();

    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data()!, doc.id);
  }

  //////////////////////////get match/////////////////////////////////////////////
  Future<MatchModel> getMatch(String id) async {
    final response = await db.collection('matches').doc(id).get();
    return MatchModel.fromMap(response.data()!, response.id);
  }

  //////////////////////////////////////////////////////////////////////////////////
}
