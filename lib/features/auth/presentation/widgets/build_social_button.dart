import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skillswap/core/constants/app_color.dart';

class BuildSocialButton extends StatelessWidget {
  const BuildSocialButton({
    super.key,
    required this.assetPath,
    required this.label,
    required this.isSvg,
    required this.onTap,
  });

  final String assetPath;
  final String label;
  final bool isSvg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.surface,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isSvg
                ? SvgPicture.asset(assetPath, height: 20, width: 20)
                : Image.asset(assetPath, height: 20, width: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
