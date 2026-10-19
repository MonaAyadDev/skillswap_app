import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillswap/core/errors/failure.dart';
import 'package:skillswap/core/models/models.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  UserRepository(this._firestore, this._auth);

  /// collection اسمها users
  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  /// رقم المستخدم الحالي، ولو مش مسجل دخول بنرمي خطأ
  String get currentUid {
    final user = _auth.currentUser;
    if (user == null) throw const Failure('You are not logged in.');
    return user.uid;
  }

  /// بيجيب بيانات مستخدم. لو ملوش مستند يرجّع null
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _users.doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!, doc.id);
    } on FirebaseException catch (e) {
      throw Failure(_message(e.code));
    }
  }

  /// بيعمل مستند جديد للمستخدم الحالي (أول مرة بعد التسجيل)
  Future<void> createProfile({
    required String name,
    required String bio,
    required String country,
  }) async {
    try {
      final uid = currentUid;
      final user = UserModel(
        uid: uid,
        name: name.trim(),
        bio: bio.trim(),
        country: country.trim(),
      );
      await _users.doc(uid).set({
        ...user.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Failure(_message(e.code));
    }
  }

  /// بيعدّل الحقول الأساسية بس من غير ما يلمس المهارات أو التقييم
  Future<void> updateProfile({
    required String name,
    required String bio,
    required String country,
  }) async {
    try {
      await _users.doc(currentUid).update({
        'name': name.trim(),
        'bio': bio.trim(),
        'country': country.trim(),
      });
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