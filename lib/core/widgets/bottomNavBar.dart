import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/constants/fonts.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem('Home', 'assets/icons/home.svg.svg', 'assets/icons/home.svg.svg'),
    _NavItem(
      'Discover',
      'assets/icons/discover.svg',
      'assets/icons/discover.svg',
    ),
    _NavItem('Matches', 'assets/icons/matches.svg', 'assets/icons/matches.svg'),
    _NavItem('Chat', 'assets/icons/chat.svg', 'assets/icons/chat.svg'),
    _NavItem('Profile', 'assets/icons/profile.svg', 'assets/icons/profile.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final selected = i == currentIndex;
              final color = selected
                  ? AppColors.primary
                  : AppColors.textSecondary;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        selected ? item.activeIcon : item.icon,
                        width: 26,
                        height: 26,
                        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String icon;
  final String activeIcon;
  const _NavItem(this.label, this.icon, this.activeIcon);
}
