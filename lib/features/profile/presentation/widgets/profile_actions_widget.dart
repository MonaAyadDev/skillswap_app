// lib/features/profile/presentation/widgets/profile_actions_widget.dart
import 'package:flutter/material.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/localization/app_translations.dart';

class ProfileActionsWidget extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onOpenSettings;

const ProfileActionsWidget({
  super.key,
  required this.onEditProfile,
  required this.onOpenSettings,
});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: onEditProfile,
            icon: const Icon(Icons.edit_outlined),
            label: Text(
              context.tr('edit_profile'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimaryOf(context),
              side: BorderSide(color: AppColors.borderOf(context)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: onOpenSettings,
            icon: const Icon(Icons.tune_rounded),
            label: Text(
              context.tr('app_settings'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}