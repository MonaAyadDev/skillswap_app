import 'package:go_router/go_router.dart';
import 'package:skillswap/core/models/user_model.dart';
import 'package:skillswap/core/routes/routes.dart';
import 'package:skillswap/features/auth/presentation/screens/login_screen.dart';
import 'package:skillswap/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:skillswap/features/chat/presentation/screens/chat_screen.dart';
import 'package:skillswap/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:skillswap/features/onboarding/onboarding_view.dart';
import 'package:skillswap/features/onboarding/splash_view.dart';
import 'package:skillswap/features/profile/presentation/screens/edit_profile_view.dart';
import 'package:skillswap/features/profile/presentation/screens/profile_setup_screen.dart';
import 'package:skillswap/features/profile/presentation/screens/profile_view.dart';
import 'package:skillswap/features/profile/presentation/screens/user_profile_screen.dart';
import 'package:skillswap/features/requests/presentation/screens/send_request_screen.dart';
import 'package:skillswap/features/settings/presentation/screens/settings_screen.dart';
import 'package:skillswap/features/skills/presentation/screens/choose_skills_screen.dart';
import 'package:skillswap/root/main_navigation_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.myProfile,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
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
      GoRoute(
        path: AppRoutes.profileSetup,
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.chooseSkills,
        builder: (context, state) => const ChooseSkillsScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainNavigationScreen(initialIndex: 0),
      ),
      GoRoute(
        path: AppRoutes.discover,
        builder: (context, state) => const MainNavigationScreen(initialIndex: 1),
      ),
      GoRoute(
        path: AppRoutes.matches,
        builder: (context, state) => const MainNavigationScreen(initialIndex: 2),
      ),
      GoRoute(
        path: AppRoutes.requests,
        builder: (context, state) => const MainNavigationScreen(initialIndex: 3),
      ),
      GoRoute(
        path: AppRoutes.myProfile,
        builder: (context, state) => const MainNavigationScreen(initialIndex: 4),
      ),
      GoRoute(
        path: AppRoutes.userProfile,
        builder: (context, state) => UserProfileScreen(
          userId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.skillRequest,
        builder: (context, state) => SendRequestScreen(
          initialData: state.extra as Map<String, dynamic>?,
        ),
      ),
      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) => ChatScreen(
          matchId: state.pathParameters['matchId'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => EditProfileView(
          initialUser: (state.extra as UserModel?) ?? ProfileView.defaultCurrentUser,
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
