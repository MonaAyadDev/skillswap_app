import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/routes/routes.dart';
import 'package:skillswap/core/models/user_model.dart';
import 'package:skillswap/features/auth/presentation/screens/login_screen.dart';
import 'package:skillswap/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:skillswap/features/discover/presentation/discover_view.dart';
import 'package:skillswap/features/home/presentation/home_view.dart';
import 'package:skillswap/features/home/presentation/screens/mainNavigation.dart';
import 'package:skillswap/features/onboarding/onboarding_view.dart';
import 'package:skillswap/features/onboarding/splash_view.dart';
import 'package:skillswap/features/profile/presentation/edit_profile_view.dart';
import 'package:skillswap/features/profile/presentation/profile_view.dart';
import 'package:skillswap/features/profile/presentation/screens/profile_setup_screen.dart';
import '../widgets/placeholder_screen.dart';

class AppRouter {
  AppRouter._();

  static const _publicRoutes = <String>{
    AppRoutes.splash,
    AppRoutes.onboarding,
    AppRoutes.login,
    AppRoutes.signUp,
  };

  static const _authOnlyRoutes = <String>{AppRoutes.login, AppRoutes.signUp};

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.mainNavigation,
    refreshListenable: _AuthRefreshNotifier(
      FirebaseAuth.instance.authStateChanges(),
    ),
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final location = state.matchedLocation;

      if (!isLoggedIn && !_publicRoutes.contains(location)) {
        return AppRoutes.login;
      }

      // مسجل وفاتح login/signup
      if (isLoggedIn && _authOnlyRoutes.contains(location)) {
        return AppRoutes.mainNavigation;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.mainNavigation,
        builder: (context, state) => const MainNavigation(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
<<<<<<< HEAD
      // ... باقي الـ routes زي ما هي بدون تغيير ...
=======
      GoRoute(
        path: AppRoutes.profileSetup,
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.chooseSkills,
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Choose Skills'),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: AppRoutes.discover,
        builder: (context, state) => const DiscoverView(),
      ),
      GoRoute(
        path: AppRoutes.userProfile,
        builder: (context, state) => ProfileView(
          user: sampleProfile(uid: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: AppRoutes.skillRequest,
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Skill Request'),
      ),
      GoRoute(
        path: AppRoutes.requests,
        builder: (context, state) => const PlaceholderScreen(title: 'Requests'),
      ),
      GoRoute(
        path: AppRoutes.matches,
        builder: (context, state) => const PlaceholderScreen(title: 'Matches'),
      ),
      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) =>
            PlaceholderScreen(title: 'Chat ${state.pathParameters['matchId']}'),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Notifications'),
      ),
      GoRoute(
        path: AppRoutes.myProfile,
        builder: (context, state) =>
            ProfileView(user: sampleProfile(), isOwnProfile: true),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) {
          final extra = state.extra;
          return EditProfileView(
            initialUser: extra is UserModel ? extra : sampleProfile(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const PlaceholderScreen(title: 'Settings'),
      ),
>>>>>>> origin/develop
    ],
  );
}

/// بيخلي الـ router يعيد تقييم الـ redirect لما حالة الـ auth تتغير
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Stream<User?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<User?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
