import 'package:flutter/material.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/models/models.dart';

class SkillSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<SkillModel> skills;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const SkillSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.skills,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills
              .map(
                (skill) => FilterChip(
                  label: Text(skill.name),
                  selected: selected.contains(skill.name),
                  onSelected: (_) => onToggle(skill.name),
                  selectedColor: color.withValues(alpha: 0.15),
                  checkmarkColor: color,
                  labelStyle: TextStyle(
                    color: selected.contains(skill.name)
                        ? color
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
