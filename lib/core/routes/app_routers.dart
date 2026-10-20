import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/routes/routes.dart';
import 'package:skillswap/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:skillswap/features/home/presentation/screens/mainNavigation.dart';
import 'package:skillswap/features/auth/presentation/screens/login_screen.dart';
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
        builder: (context, state) => const PlaceholderScreen(title: 'Splash'),
      ),
      GoRoute(
        path: AppRoutes.mainNavigation,
        builder: (context, state) => const MainNavigation(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Onboarding'),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      // ... باقي الـ routes زي ما هي بدون تغيير ...
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
