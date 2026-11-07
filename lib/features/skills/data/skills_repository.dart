import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillswap/core/errors/failure.dart';
import 'package:skillswap/core/models/models.dart';

class SkillsRepository {
  final FirebaseFirestore _firestore;
  SkillsRepository(this._firestore);

  Future<void> updateSkills({
    required String userId,
    required List<String> teachSkills,
    required List<String> learnSkills,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'teachSkills': teachSkills,
        'learnSkills': learnSkills,
      });
    } on FirebaseException catch (e) {
      throw Failure(_message(e.code));
    }
  }
  
  Future<List<SkillModel>> getSkills() async {
    try {
      final snapshot =
          await _firestore.collection('skills').orderBy('name').get();
      return snapshot.docs
          .map((doc) => SkillModel.fromMap(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw Failure(_message(e.code));
    }
  }

  String _message(String code) {
    switch (code) {
      case 'permission-denied':
        return 'You do not have permission to do this.';
      case 'unavailable':
        return 'No connection. Please try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}