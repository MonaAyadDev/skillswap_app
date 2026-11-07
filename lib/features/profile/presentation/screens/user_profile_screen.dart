import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/localization/app_translations.dart';
import 'package:skillswap/core/models/user_model.dart';
import 'package:skillswap/core/routes/routes.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  static final Map<String, UserModel> _membersMap = {
    'alex-morgan': const UserModel(
      uid: 'alex-morgan',
      name: 'Alex Morgan',
      country: 'United States (San Francisco)',
      bio:
          'Senior Product Designer with 6+ years specializing in design systems, micro-interactions, and Figma components. Passionate about empowering engineers to design better interfaces.',
      teachSkills: ['UI/UX Design', 'Figma Systems', 'User Research', 'Design Systems'],
      learnSkills: ['Flutter Development', 'Dart', 'State Management'],
      ratingAvg: 4.9,
      ratingCount: 38,
    ),
    'jordan-lee': const UserModel(
      uid: 'jordan-lee',
      name: 'Jordan Lee',
      country: 'Canada (Toronto)',
      bio:
          'Frontend engineer and accessibility advocate. Love building scalable web interfaces with React, Next.js, and TypeScript. Looking for creative design coaching.',
      teachSkills: ['Web Development', 'JavaScript', 'HTML & CSS', 'React.js'],
      learnSkills: ['UI/UX Design', 'Public Speaking', 'Branding'],
      ratingAvg: 4.8,
      ratingCount: 29,
    ),
    'sam-rivera': const UserModel(
      uid: 'sam-rivera',
      name: 'Sam Rivera',
      country: 'Spain (Barcelona)',
      bio:
          'Professional portrait and street photographer. Excited to teach camera manual modes, natural lighting, and Lightroom editing in exchange for web development guidance.',
      teachSkills: ['Photography', 'Photo Editing', 'Lightroom', 'Composition'],
      learnSkills: ['Spanish', 'Graphic Design', 'Web Development'],
      ratingAvg: 5.0,
      ratingCount: 42,
    ),
    'taylor-kim': const UserModel(
      uid: 'taylor-kim',
      name: 'Taylor Kim',
      country: 'South Korea (Seoul)',
      bio:
          'Data analyst & Python developer. Enjoy automating tedious tasks and uncovering insights from complex datasets. Looking to learn creative illustration.',
      teachSkills: ['Python', 'Data Analysis', 'SQL', 'Automation'],
      learnSkills: ['Digital Illustration', 'Korean', 'Figma'],
      ratingAvg: 4.7,
      ratingCount: 19,
    ),
    'casey-patel': const UserModel(
      uid: 'casey-patel',
      name: 'Casey Patel',
      country: 'United Kingdom (London)',
      bio:
          'Speech coach and content writer. Helping tech leaders pitch with confidence and communicate ideas clearly. Eager to master web basics.',
      teachSkills: ['Public Speaking', 'Storytelling', 'Copywriting', 'Debate'],
      learnSkills: ['Web Development', 'Photography', 'Podcasting'],
      ratingAvg: 4.9,
      ratingCount: 31,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final user = _membersMap[userId] ??
        UserModel(
          uid: userId,
          name: userId.replaceAll('-', ' ').toUpperCase(),
          country: 'Global Member',
          bio: 'Passionate learner and mentor sharing knowledge on SkillSwap.',
          teachSkills: const ['UI/UX Design', 'Coding Basics'],
          learnSkills: const ['Languages', 'Marketing'],
          ratingAvg: 4.9,
          ratingCount: 15,
        );

    final initials = user.name
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join();

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.isArabic
                            ? 'تم نسخ رابط الملف إلى الحافظة!'
                            : 'Profile link copied to clipboard!',
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border_rounded),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.isArabic
                            ? 'تم حفظ المستخدم في المفضلة!'
                            : 'User saved to bookmarks!',
                      ),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF630ED4), Color(0xFF8B6DE9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 42,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            initials.isNotEmpty ? initials : 'U',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimaryOf(context),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.verified_rounded, color: AppColors.primary, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondaryOf(context)),
                      const SizedBox(width: 4),
                      Text(
                        user.country,
                        style: TextStyle(color: AppColors.textSecondaryOf(context), fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
                        _buildStat(context, context.tr('rating'), '${user.ratingAvg} ★', AppColors.warning),
                        Container(width: 1, height: 30, color: AppColors.dividerOf(context)),
                        _buildStat(context, context.tr('reviews'), '${user.ratingCount}', AppColors.primary),
                        Container(width: 1, height: 30, color: AppColors.dividerOf(context)),
                        _buildStat(context, context.tr('swaps_done'), '18', AppColors.success),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.push(
                              AppRoutes.skillRequest,
                              extra: {
                                'userId': user.uid,
                                'userName': user.name,
                                'teachSkills': user.teachSkills,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.swap_calls_rounded),
                          label: Text(
                            context.tr('swap_request'),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.push(AppRoutes.chat.replaceFirst(':matchId', 'chat_${user.uid}'));
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline_rounded),
                          label: Text(
                            context.tr('chat'),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context: context,
                    title: context.tr('about_me'),
                    child: Text(
                      user.bio,
                      style: TextStyle(
                        color: AppColors.textSecondaryOf(context),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    context: context,
                    title: context.tr('can_teach'),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: user.teachSkills.map((skill) {
                        return Chip(
                          backgroundColor: AppColors.isDark(context)
                              ? AppColors.primary.withValues(alpha: 0.25)
                              : AppColors.primarySoft,
                          side: BorderSide.none,
                          avatar: const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 16),
                          label: Text(
                            skill,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    context: context,
                    title: context.tr('wants_to_learn'),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: user.learnSkills.map((skill) {
                        return Chip(
                          backgroundColor: AppColors.isDark(context)
                              ? AppColors.info.withValues(alpha: 0.25)
                              : AppColors.infoLight,
                          side: BorderSide.none,
                          avatar: const Icon(Icons.lightbulb_outline_rounded, color: AppColors.info, size: 16),
                          label: Text(
                            skill,
                            style: const TextStyle(
                              color: AppColors.info,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    context: context,
                    title: '${context.tr('reviews')} (${user.ratingCount})',
                    child: Column(
                      children: [
                        _buildReviewItem(
                          context,
                          'Elena Rostova',
                          '5.0',
                          'Super patient mentor! Alex explained Figma auto-layout and component variants clearly in just one session.',
                          '3 days ago',
                        ),
                        Divider(height: 20, color: AppColors.dividerOf(context)),
                        _buildReviewItem(
                          context,
                          'David Chen',
                          '4.9',
                          'Great communicator and very knowledgeable. Our weekly exchange went smoothly without a hitch.',
                          '1 week ago',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value, Color color) {
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

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryOf(context),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildReviewItem(
    BuildContext context,
    String name,
    String rating,
    String comment,
    String date,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primarySoft,
              child: Text(
                name[0],
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.textPrimaryOf(context),
              ),
            ),
            const Spacer(),
            const Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
            const SizedBox(width: 2),
            Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(width: 8),
            Text(date, style: TextStyle(color: AppColors.textMutedOf(context), fontSize: 11)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          comment,
          style: TextStyle(color: AppColors.textSecondaryOf(context), fontSize: 12.5),
        ),
      ],
    );
  }
}
