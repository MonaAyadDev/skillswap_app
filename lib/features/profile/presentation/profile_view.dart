import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/models/user_model.dart';
import 'package:skillswap/core/routes/routes.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
    required this.user,
    this.isOwnProfile = false,
  });

  final UserModel user;
  final bool isOwnProfile;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late UserModel _user = widget.user;

  Future<void> _editProfile() async {
    final updatedUser = await context.push<UserModel>(
      AppRoutes.editProfile,
      extra: _user,
    );
    if (updatedUser != null && mounted) {
      setState(() => _user = updatedUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(widget.isOwnProfile ? 'My Profile' : 'Profile'),
        actions: [
          if (widget.isOwnProfile)
            IconButton(
              onPressed: _editProfile,
              tooltip: 'Edit profile',
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 700 ? 32.0 : 20.0;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    32,
                  ),
                  children: [
                    _buildIdentityCard(context),
                    const SizedBox(height: 16),
                    _ProfileSection(
                      title: 'About',
                      child: Text(
                        _user.bio.isEmpty
                            ? 'Add a short introduction to tell others about yourself.'
                            : _user.bio,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ProfileSection(
                      title: 'Skills I can teach',
                      child: _SkillList(
                        skills: _user.teachSkills,
                        emptyMessage: 'No skills added yet.',
                        accentColor: AppColors.primary,
                        backgroundColor: AppColors.primarySoft,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ProfileSection(
                      title: 'Skills I want to learn',
                      child: _SkillList(
                        skills: _user.learnSkills,
                        emptyMessage: 'No learning goals added yet.',
                        accentColor: const Color(0xFF4588DB),
                        backgroundColor: const Color(0xFFEAF3FF),
                      ),
                    ),
                    if (widget.isOwnProfile) ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _editProfile,
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Profile'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildIdentityCard(BuildContext context) {
    final name = _user.name.trim().isEmpty ? 'SkillSwap Member' : _user.name;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 43,
            backgroundColor: AppColors.primarySoft,
            backgroundImage: _user.photoUrl.isEmpty
                ? null
                : NetworkImage(_user.photoUrl),
            child: _user.photoUrl.isEmpty
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_user.country.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 17,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  _user.country,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
          if (_user.ratingCount > 0) ...[
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
                  '${_user.ratingAvg.toStringAsFixed(1)} · ${_user.ratingCount} reviews',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
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
    return parts.take(2).map((part) => part[0].toUpperCase()).join();
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SkillList extends StatelessWidget {
  const _SkillList({
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

UserModel sampleProfile({String uid = 'current-member'}) {
  return UserModel(
    uid: uid,
    name: uid == 'current-member' ? 'Jamie Parker' : 'SkillSwap Member',
    bio:
        'I enjoy sharing what I know, learning from others, and building new skills through collaboration.',
    country: 'United States',
    teachSkills: const ['UI/UX Design', 'Figma', 'Prototyping'],
    learnSkills: const ['Photography', 'Public Speaking'],
    ratingAvg: 4.9,
    ratingCount: 12,
  );
}
