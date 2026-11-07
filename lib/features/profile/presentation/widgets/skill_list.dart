import 'package:flutter/material.dart';
import 'package:skillswap/core/constants/app_color.dart';

class SkillList extends StatelessWidget {
  const SkillList({
    super.key,
    required this.skills,
    required this.emptyMessage,
    required this.accentColor,
    required this.backgroundColor,
  });
  final List<String> skills;
  final String emptyMessage;
  final Color accentColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return Text(
        emptyMessage,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills
          .map(
            (skill) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                skill,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
