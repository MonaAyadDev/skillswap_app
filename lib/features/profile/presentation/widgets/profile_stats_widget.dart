// lib/features/profile/presentation/widgets/profile_stats_widget.dart
import 'package:flutter/material.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/localization/app_translations.dart';

class ProfileStatsWidget extends StatelessWidget {
  final String swapsCount;
  final double ratingAvg;
  final int ratingCount;

const ProfileStatsWidget({
  super.key,
  required this.swapsCount,
  required this.ratingAvg,
  required this.ratingCount,
});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatItem(context, context.tr('swaps_done'), swapsCount, AppColors.primary)),
          Container(width: 1, height: 35, color: AppColors.dividerOf(context)),
          Expanded(child: _buildStatItem(context, context.tr('rating'), '$ratingAvg ★', AppColors.warning)),
          Container(width: 1, height: 35, color: AppColors.dividerOf(context)),
          Expanded(child: _buildStatItem(context, context.tr('reviews'), '$ratingCount', AppColors.success)),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: AppColors.textSecondaryOf(context), fontSize: 12),
          ),
        ],
      ),
    );
  }
}