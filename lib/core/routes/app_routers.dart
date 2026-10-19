import 'package:go_router/go_router.dart';
import 'package:skillswap/core/routes/routes.dart';
import 'package:skillswap/features/onboarding/onboarding_view.dart';
import 'package:skillswap/features/onboarding/splash_view.dart';
import 'package:skillswap/features/home/presentation/home_view.dart';
import 'package:skillswap/features/discover/presentation/discover_view.dart';
import 'package:skillswap/core/models/user_model.dart';
import 'package:skillswap/features/profile/presentation/edit_profile_view.dart';
import 'package:skillswap/features/profile/presentation/profile_view.dart';
import '../widgets/placeholder_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
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
        builder: (context, state) => const PlaceholderScreen(title: 'Login'),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const PlaceholderScreen(title: 'Sign Up'),
      ),
      GoRoute(
        path: AppRoutes.profileSetup,
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Profile Setup'),
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
    ],
  );
}
