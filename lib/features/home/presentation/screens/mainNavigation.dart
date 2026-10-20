import 'package:flutter/material.dart';
import 'package:skillswap/core/widgets/bottomNavBar.dart';
import 'package:skillswap/core/widgets/placeholder_screen.dart';
import 'package:skillswap/features/matches/presentation/screens/match_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0; // 0 = Home

  final _screens = [
    const PlaceholderScreen(title: 'Home'),
    const PlaceholderScreen(title: 'Discover'),
    MatchScreen(),
    const PlaceholderScreen(title: 'Chat'),
    const PlaceholderScreen(title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
