import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/models/match_model.dart';
import 'package:skillswap/core/models/user_model.dart';
import 'package:skillswap/core/widgets/appHeader.dart';
import 'package:skillswap/features/auth/presentation/screens/login_screen.dart';
import 'package:skillswap/features/matches/presentation/widgets/bannerMatches.dart';
import 'package:skillswap/features/matches/presentation/widgets/matchCard.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  Future<UserModel?> _getUser(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final data = doc.data();
      if (!doc.exists || data == null) {
        debugPrint('User doc not found: $uid');
        return null;
      }
      return UserModel.fromMap(data, doc.id);
    } catch (e) {
      debugPrint('Error loading user $uid: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AppHeader(title: 'Matches'),
              const Text('People ready to exchange skills with you'),
              const SizedBox(height: 32),
              Expanded(
                child: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  initialData: FirebaseAuth.instance.currentUser,
                  builder: (context, authSnap) {
                    final user = authSnap.data;
                    if (user == null) {
                      return Center(
                        child: TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          ),
                          child: const Text(
                            'Please log in to see your matches',
                          ),
                        ),
                      );
                    }
                    return _buildMatches(user.uid);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatches(String myUid) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('matches')
          .where('userIds', arrayContains: myUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];
        final matches = docs
            .map((d) => MatchModel.fromMap(d.data(), d.id))
            .toList();

        if (matches.isEmpty) {
          return const Center(child: Text('No matches yet'));
        }

        return Column(
          children: [
            MutualMatchesBanner(count: matches.length),
            const SizedBox(height: 16),
            TextButton(onPressed: () {}, child: const Text('Requests')),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final match = matches[index];
                  final otherUid = match.userIds.firstWhere(
                    (id) => id != myUid,
                    orElse: () => '',
                  );
                  if (otherUid.isEmpty) return const SizedBox.shrink();

                  return FutureBuilder<UserModel?>(
                    future: _getUser(otherUid),
                    builder: (context, userSnap) {
                      if (userSnap.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (userSnap.hasError) {
                        return Text('Error: ${userSnap.error}');
                      }
                      final otherUser = userSnap.data;
                      if (otherUser == null) return const SizedBox.shrink();

                      return MatchCardWidget(
                        matchModel: match,
                        user: otherUser,
                        mySkills: match.skillsExchanged.join(' & '),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
