import 'package:flutter/material.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/models/user_model.dart';

class IdentityCardWidget extends StatelessWidget {
  const IdentityCardWidget({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final name = user.name.trim().isEmpty ? 'SkillSwap Member' : user.name;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 43,
            backgroundColor: AppColors.isDark(context)
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.primarySoft,
            backgroundImage: user.photoUrl.isEmpty
                ? null
                : NetworkImage(user.photoUrl),
            child: user.photoUrl.isEmpty
                ? Text(
                    _initials(name),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 14),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimaryOf(context),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (user.country.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 17,
                  color: AppColors.textMutedOf(context),
                ),
                const SizedBox(width: 4),
                Text(
                  user.country,
                  style: TextStyle(color: AppColors.textSecondaryOf(context)),
                ),
              ],
            ),
          ],
          if (user.ratingCount > 0) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 19,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 4),
                Text(
                  '${user.ratingAvg.toStringAsFixed(1)} · ${user.ratingCount} reviews',
                  style: TextStyle(
                    color: AppColors.textSecondaryOf(context),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    return parts.take(2).map((part) => part.isNotEmpty ? part[0].toUpperCase() : '').join();
  }
}
