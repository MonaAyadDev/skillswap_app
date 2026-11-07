// lib/features/profile/presentation/profile_view.dart
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/localization/app_translations.dart';
import 'package:skillswap/core/models/user_model.dart';
import 'package:skillswap/core/routes/routes.dart';



import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillswap/features/profile/presentation/widgets/identity_card_widget.dart';
import 'package:skillswap/features/profile/presentation/widgets/profile_section.dart';
import 'package:skillswap/features/profile/presentation/widgets/skill_list.dart';
import 'package:skillswap/features/profile/presentation/widgets/profile_stats_widget.dart';
import 'package:skillswap/features/profile/presentation/widgets/profile_actions_widget.dart';

class ProfileView extends StatefulWidget {
  final UserModel? user;
  final bool isOwnProfile;

  const ProfileView({
    super.key,
    this.user,
    this.isOwnProfile = true,
  });

  static const UserModel defaultCurrentUser = UserModel(
    uid: 'current_user',
    name: 'Elena Rostova',
    bio: 'Product designer passionate about typography, Figma systems, and watercolor painting. Excited to teach UI design in exchange for Spanish conversational practice and coding.',
    country: 'San Francisco, CA (United States)',
    teachSkills: ['UI/UX Design', 'Figma Systems', 'Prototyping', 'Design Thinking'],
    learnSkills: ['Flutter Development', 'Spanish Conversational', 'Photography'],
    ratingAvg: 4.9,
    ratingCount: 24,
  );

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late UserModel _user = widget.user ?? ProfileView.defaultCurrentUser;

  Future<void> _editProfile() async {
    final updatedUser = await context.push<UserModel>(
      AppRoutes.editProfile,
      extra: _user,
    );

    if (!mounted) return;

    if (updatedUser != null) {
      setState(() {
        _user = updatedUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOf(context),
        elevation: 0,
        title: Text(
          widget.isOwnProfile ? context.tr('my_profile') : context.tr('profile'),
          style: TextStyle(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        iconTheme: IconThemeData(
          color: AppColors.textPrimaryOf(context),
        ),
        actions: [
          if (widget.isOwnProfile) ...[
            IconButton(
              onPressed: _editProfile,
              tooltip: context.tr('edit_profile'),
              icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            ),
            IconButton(
              onPressed: () => context.push(AppRoutes.settings),
              tooltip: context.tr('settings_title'),
              icon: Icon(Icons.settings_outlined, color: AppColors.textPrimaryOf(context)),
            ),
          ],
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 700 ? 32.0 : 16.0;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 32),
                  children: [
                    IdentityCardWidget(user: _user),
                    const SizedBox(height: 16),
                    
                    // Stats Summary Widget
                    ProfileStatsWidget(
                      swapsCount: '14',
                      ratingAvg: _user.ratingAvg,
                      ratingCount: _user.ratingCount,
                    ),
                    const SizedBox(height: 16),

                    // About Me
                    ProfileSection(
                      title: context.tr('about_me'),
                      child: Text(
                        _user.bio.isEmpty
                            ? (context.isArabic
                                ? 'أضف نبذة قصيرة لتعريف الآخرين باهتماماتك.'
                                : 'Add a short introduction to tell others about yourself.')
                            : _user.bio,
                        softWrap: true,
                        style: TextStyle(
                          color: AppColors.textSecondaryOf(context),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Skills I Teach
                    ProfileSection(
                      title: context.tr('skills_teach'),
                      child: SkillList(
                        skills: _user.teachSkills,
                        emptyMessage: context.isArabic ? 'لم تتم إضافة مهارات بعد.' : 'No skills added yet.',
                        accentColor: AppColors.primary,
                        backgroundColor: AppColors.isDark(context)
                            ? AppColors.primary.withValues(alpha: 0.25)
                            : AppColors.primarySoft,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Skills I Want to Learn
                    ProfileSection(
                      title: context.tr('skills_learn'),
                      child: SkillList(
                        skills: _user.learnSkills,
                        emptyMessage: context.isArabic ? 'لم تتم إضافة أهداف تعلم بعد.' : 'No learning goals added yet.',
                        accentColor: AppColors.info,
                        backgroundColor: AppColors.isDark(context)
                            ? AppColors.info.withValues(alpha: 0.25)
                            : AppColors.infoLight,
                      ),
                    ),

                    if (widget.isOwnProfile) ...[
                      const SizedBox(height: 24),
                      ProfileActionsWidget(
                        onEditProfile: _editProfile,
                        onOpenSettings: () => context.push(AppRoutes.settings),
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
}