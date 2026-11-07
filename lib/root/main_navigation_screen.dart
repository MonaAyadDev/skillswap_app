import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/localization/app_translations.dart';
import 'package:skillswap/features/discover/presentation/discover_view.dart';
import 'package:skillswap/features/home/presentation/home_view.dart';
import 'package:skillswap/features/matches/presentation/screens/matches_screen.dart';
import 'package:skillswap/features/profile/presentation/screens/profile_view.dart';
import 'package:skillswap/features/requests/presentation/screens/requests_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    HomeView(),
    DiscoverView(),
    MatchesScreen(),
    RequestsScreen(),
    ProfileView(isOwnProfile: true),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16.r,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: AppColors.isDark(context)
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.primarySoft,
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );
                }
                return TextStyle(
                  color: AppColors.textSecondaryOf(context),
                  fontSize: 12,
                );
              }),
            ),
            child: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
              backgroundColor: AppColors.surfaceOf(context),
              elevation: 0,
              height: 65.h,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home_rounded, color: AppColors.primary),
                  label: context.tr('nav_home'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.explore_outlined),
                  selectedIcon: const Icon(Icons.explore_rounded, color: AppColors.primary),
                  label: context.tr('nav_discover'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.swap_horiz_rounded),
                  selectedIcon: const Icon(Icons.swap_horizontal_circle_rounded, color: AppColors.primary),
                  label: context.tr('nav_matches'),
                ),
                NavigationDestination(
                  icon: const Badge(
                    label: Text('2'),
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.assignment_outlined),
                  ),
                  selectedIcon: const Badge(
                    label: Text('2'),
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.assignment_rounded, color: AppColors.primary),
                  ),
                  label: context.tr('nav_requests'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline_rounded),
                  selectedIcon: const Icon(Icons.person_rounded, color: AppColors.primary),
                  label: context.tr('nav_profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
