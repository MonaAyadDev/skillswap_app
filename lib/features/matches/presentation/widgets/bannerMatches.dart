import 'package:flutter/material.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/constants/fonts.dart';

class MutualMatchesBanner extends StatelessWidget {
  final int count;

  const MutualMatchesBanner({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF7B3FF0), AppColors.primary, Color(0xFF6E6A8C)],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text('🎉', style: TextStyle(fontSize: 26)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count == 1
                      ? '1 Mutual Match ready!'
                      : '$count Mutual Matches ready!',
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textOnPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Both of you accepted each other's swap trade",
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
