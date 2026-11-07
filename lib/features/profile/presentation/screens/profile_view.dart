import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/localization/app_translations.dart';
import 'package:skillswap/core/models/user_model.dart';
import 'package:skillswap/core/routes/routes.dart';
import 'package:skillswap/features/profile/presentation/widgets/identity_card_widget.dart';
import 'package:skillswap/features/profile/presentation/widgets/profile_section.dart';
import 'package:skillswap/features/profile/presentation/widgets/skill_list.dart';

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
    bio:
        'Product designer passionate about typography, Figma systems, and watercolor painting. Excited to teach UI design in exchange for Spanish conversational practice and coding.',
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
    if (updatedUser != null && mounted) {
      setState(() => _user = updatedUser);
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
            fontSize: 20,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimaryOf(context)),
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
                    IdentityCardWidget(user: _user),
                    const SizedBox(height: 16),

                    // Stats summary card
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceOf(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderOf(context)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(context.tr('swaps_done'), '14', AppColors.primary),
                          Container(width: 1, height: 30, color: AppColors.dividerOf(context)),
                          _buildStatItem(context.tr('rating'), '${_user.ratingAvg} ★', AppColors.warning),
                          Container(width: 1, height: 30, color: AppColors.dividerOf(context)),
                          _buildStatItem(context.tr('reviews'), '${_user.ratingCount}', AppColors.success),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    ProfileSection(
                      title: context.tr('about_me'),
                      child: Text(
                        _user.bio.isEmpty
                            ? (context.isArabic ? 'أضف نبذة قصيرة لتعريف الآخرين باهتماماتك.' : 'Add a short introduction to tell others about yourself.')
                            : _user.bio,
                        style: TextStyle(
                          color: AppColors.textSecondaryOf(context),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                      SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textOnPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: _editProfile,
                          icon: const Icon(Icons.edit_outlined),
                          label: Text(
                            context.tr('edit_profile'),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimaryOf(context),
                            side: BorderSide(color: AppColors.borderOf(context)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () => context.push(AppRoutes.settings),
                          icon: const Icon(Icons.tune_rounded),
                          label: Text(
                            context.tr('app_settings'),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
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

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondaryOf(context), fontSize: 12),
        ),
      ],
    );
  }
}
