import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillswap/core/errors/failure.dart';

class SettingsRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  SettingsRepository(this._auth, this._firestore);

  /// بنتأكد من الباسورد الحالي (Firebase بيطلب ده للعمليات الحساسة)
  Future<void> _reauthenticate(User user, String password) {
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    return user.reauthenticateWithCredential(credential);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw const Failure('You are not logged in.');
    try {
      await _reauthenticate(user, currentPassword);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw Failure(_message(e.code));
    }
  }

  Future<void> deleteAccount({required String password}) async {
    final user = _auth.currentUser;
    if (user == null) throw const Failure('You are not logged in.');
    try {
      await _reauthenticate(user, password);
      // نمسح بيانات المستخدم الأول، وبعدين الحساب نفسه
      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw Failure(_message(e.code));
    } on FirebaseException catch (e) {
      throw Failure(_message(e.code));
    }
  }

  Future<void> logout() => _auth.signOut();

  String _message(String code) {
    switch (code) {
      case 'wrong-password':
      case 'invalid-credential':
        return 'Current password is incorrect.';
      case 'weak-password':
        return 'New password is too weak (minimum 6 characters).';
      case 'requires-recent-login':
        return 'Please log in again and retry.';
      case 'network-request-failed':
      case 'unavailable':
        return 'No internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'permission-denied':
        return 'You do not have permission to do this.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}