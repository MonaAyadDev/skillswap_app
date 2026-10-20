import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/constants/fonts.dart';
import 'package:skillswap/core/models/models.dart';

class MatchCardWidget extends StatelessWidget {
  const MatchCardWidget({
    super.key,
    required this.matchModel,
    required this.user,
    required this.mySkills,
    this.onChat,
    this.onSchedule,
  });

  final MatchModel matchModel;
  final UserModel user;
  final String mySkills;
  final VoidCallback? onChat;
  final VoidCallback? onSchedule;

  static const _tealText = Color(0xFF0B7A55);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bioRow(),
          const SizedBox(height: 14),
          _skillsBox(),
          const SizedBox(height: 14),
          _actionsRow(),
        ],
      ),
    );
  }

  // ---------------- bio ----------------
  Widget _bioRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: user.photoUrl.isNotEmpty
                  ? Image.network(
                      user.photoUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 56,
                      height: 56,
                      color: AppColors.primaryLight,
                    ),
            ),
            Positioned(
              right: -4,
              bottom: -4,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.online,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 2.5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      user.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.verified,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      user.country,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '4.9 (${user.ratingCount} swaps)',
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // ---------------- skills box ----------------
  Widget _skillsBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _skillColumn(
              label: 'SHE TEACHES YOU',
              skill: user.teachSkills.join(' & '),
              color: AppColors.primary,
              dotColor: const Color(0xFF7B3FF0),
              alignEnd: false,
            ),
          ),
          Container(
            width: 44,
            height: 44,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(11),
            child: SvgPicture.asset(
              'assets/icons/matches.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          Expanded(
            child: _skillColumn(
              label: 'YOU TEACH HER',
              skill: mySkills,
              color: _tealText,
              dotColor: _tealText,
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _skillColumn({
    required String label,
    required String skill,
    required Color color,
    required Color dotColor,
    required bool alignEnd,
  }) {
    final dot = Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
    );
    final text = Flexible(
      child: Text(
        skill,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        style: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: alignEnd
              ? [text, const SizedBox(width: 6), dot]
              : [dot, const SizedBox(width: 6), text],
        ),
      ],
    );
  }

  // ---------------- actions ----------------
  Widget _actionsRow() {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: 'Chat Now',
            icon: SvgPicture.asset(
              'assets/icons/chat.svg',
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            background: AppColors.primary,
            foreground: Colors.white,
            onTap: onChat,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            label: 'Schedule',
            icon: const Icon(Icons.abc, size: 22, color: AppColors.primary),
            background: AppColors.primaryLight,
            foreground: AppColors.textPrimary,
            onTap: onSchedule,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    this.onTap,
  });

  final String label;
  final Widget icon;
  final Color background;
  final Color foreground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: SizedBox(
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
