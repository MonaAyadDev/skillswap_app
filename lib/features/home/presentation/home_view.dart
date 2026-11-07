import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/localization/app_translations.dart';
import 'package:skillswap/core/routes/routes.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<_SkillCategory> _categories = [
    _SkillCategory(
      title: 'Design & Creative',
      titleAr: 'التصميم والإبداع',
      subtitle: 'Create something remarkable',
      subtitleAr: 'أتقن واجهات المستخدم والرسوم',
      icon: Icons.palette_outlined,
      color: Color(0xFF8B6DE9),
      backgroundColor: Color(0xFFF1EDFF),
    ),
    _SkillCategory(
      title: 'Tech & Code',
      titleAr: 'البرمجة والتقنية',
      subtitle: 'Build your next big idea',
      subtitleAr: 'تعلم التطبيقات والويب باحترافية',
      icon: Icons.code_rounded,
      color: Color(0xFF4588DB),
      backgroundColor: Color(0xFFEAF3FF),
    ),
  ];

  static const List<_MemberMatch> _matches = [
    _MemberMatch(
      id: 'alex-morgan',
      name: 'Alex Morgan',
      initials: 'AM',
      skill: 'UI/UX Design',
      offering: 'Offers: Figma',
      rating: '4.9',
      color: Color(0xFFE5D7CB),
    ),
    _MemberMatch(
      id: 'jordan-lee',
      name: 'Jordan Lee',
      initials: 'JL',
      skill: 'Web Development',
      offering: 'Offers: JavaScript',
      rating: '4.8',
      color: Color(0xFFD6E8E3),
    ),
    _MemberMatch(
      id: 'sam-rivera',
      name: 'Sam Rivera',
      initials: 'SR',
      skill: 'Photography',
      offering: 'Offers: Portraits',
      rating: '5.0',
      color: Color(0xFFEBD9E8),
    ),
  ];

  static const List<_TrendingSkill> _trendingSkills = [
    _TrendingSkill(
      name: 'UI/UX Design',
      nameAr: 'تصميم واجهات المستخدم UI/UX',
      learners: '1.2k learners',
      learnersAr: '١٫٢ ألف متعلم',
      icon: Icons.design_services_outlined,
    ),
    _TrendingSkill(
      name: 'Python',
      nameAr: 'لغة بايثون Python',
      learners: '980 learners',
      learnersAr: '٩٨٠ متعلم',
      icon: Icons.terminal_rounded,
    ),
    _TrendingSkill(
      name: 'Photography',
      nameAr: 'التصوير الاحترافي',
      learners: '760 learners',
      learnersAr: '٧٦٠ متعلم',
      icon: Icons.photo_camera_outlined,
    ),
    _TrendingSkill(
      name: 'Public Speaking',
      nameAr: 'الإلقاء والتحدث العام',
      learners: '640 learners',
      learnersAr: '٦٤٠ متعلم',
      icon: Icons.record_voice_over_outlined,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _normalizedQuery => _searchQuery.trim().toLowerCase();

  List<_SkillCategory> get _visibleCategories {
    if (_normalizedQuery.isEmpty) return _categories;
    return _categories
        .where(
          (category) =>
              category.title.toLowerCase().contains(_normalizedQuery) ||
              category.titleAr.toLowerCase().contains(_normalizedQuery),
        )
        .toList();
  }

  List<_MemberMatch> get _visibleMatches {
    if (_normalizedQuery.isEmpty) return _matches;
    return _matches
        .where(
          (match) =>
              match.name.toLowerCase().contains(_normalizedQuery) ||
              match.skill.toLowerCase().contains(_normalizedQuery),
        )
        .toList();
  }

  List<_TrendingSkill> get _visibleTrendingSkills {
    if (_normalizedQuery.isEmpty) return _trendingSkills;
    return _trendingSkills
        .where((skill) =>
            skill.name.toLowerCase().contains(_normalizedQuery) ||
            skill.nameAr.toLowerCase().contains(_normalizedQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 700 ? 32.0 : 20.0;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: CustomScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        20,
                        horizontalPadding,
                        32,
                      ),
                      sliver: SliverList.list(
                        children: [
                          _buildHeader(context),
                          const SizedBox(height: 24),
                          _buildSearchBar(),
                          const SizedBox(height: 32),
                          _buildSectionHeader(
                            title: context.tr('explore_categories'),
                            actionLabel: context.tr('see_all'),
                            onAction: () => context.go(AppRoutes.discover),
                          ),
                          const SizedBox(height: 16),
                          _buildCategories(),
                          const SizedBox(height: 32),
                          _buildSectionHeader(
                            title: context.tr('recommended_matches'),
                            actionLabel: context.tr('see_all'),
                            onAction: () => context.go(AppRoutes.matches),
                          ),
                          const SizedBox(height: 16),
                          _buildRecommendedMatches(),
                          const SizedBox(height: 32),
                          _buildSectionHeader(
                            title: context.tr('trending_skills'),
                            actionLabel: context.isArabic ? 'استكشف' : 'Explore',
                            onAction: () => context.go(AppRoutes.discover),
                          ),
                          const SizedBox(height: 16),
                          _buildTrendingSkills(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('good_morning'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.tr('find_next_skill'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimaryOf(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => context.push(AppRoutes.notifications),
          tooltip: 'Notifications',
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surfaceOf(context),
            foregroundColor: AppColors.textPrimaryOf(context),
            fixedSize: const Size(48, 48),
          ),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _searchQuery = value),
      textInputAction: TextInputAction.search,
      style: TextStyle(color: AppColors.textPrimaryOf(context)),
      decoration: InputDecoration(
        hintText: context.tr('search_placeholder'),
        prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMutedOf(context)),
        suffixIcon: _searchQuery.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
                icon: const Icon(Icons.close_rounded),
              ),
        filled: true,
        fillColor: AppColors.surfaceOf(context),
        hintStyle: TextStyle(color: AppColors.textMutedOf(context)),
        prefixIconColor: AppColors.textMutedOf(context),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.borderOf(context)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.borderOf(context)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimaryOf(context),
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: Text(
            actionLabel,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    final categories = _visibleCategories;
    if (categories.isEmpty) {
      return _EmptySearchResult(
        message: context.isArabic ? 'لم يتم العثور على تصنيفات.' : 'No matching categories.',
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 12.0;
        final width = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: categories
              .map(
                (category) => SizedBox(
                  width: width,
                  child: _CategoryCard(
                    category: category,
                    onTap: () => context.go(AppRoutes.discover),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildRecommendedMatches() {
    final matches = _visibleMatches;
    if (matches.isEmpty) {
      return _EmptySearchResult(
        message: context.isArabic ? 'لم يتم العثور على أشخاص متوافقين.' : 'No matching people found.',
      );
    }
    return SizedBox(
      height: 194,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: matches.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final match = matches[index];
          return SizedBox(
            width: 250,
            child: _MatchCard(
              match: match,
              onTap: () => context.push(
                AppRoutes.userProfile.replaceFirst(':id', match.id),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendingSkills() {
    final skills = _visibleTrendingSkills;
    if (skills.isEmpty) {
      return _EmptySearchResult(
        message: context.isArabic ? 'لم يتم العثور على مهارات.' : 'No matching skills.',
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: skills.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final skill = skills[index];
        return _TrendingSkillTile(
          skill: skill,
          onTap: () => context.go(AppRoutes.discover),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.onTap});

  final _SkillCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    return Material(
      color: AppColors.isDark(context)
          ? category.color.withValues(alpha: 0.18)
          : category.backgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(category.icon, color: category.color),
              ),
              const SizedBox(height: 20),
              Text(
                isArabic ? category.titleAr : category.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textPrimaryOf(context),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                isArabic ? category.subtitleAr : category.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textSecondaryOf(context),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({required this.match, required this.onTap});

  final _MemberMatch match;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceOf(context),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderOf(context)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: match.color,
                    child: Text(
                      match.initials,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFF2A93B),
                    size: 19,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    match.rating,
                    style: TextStyle(
                      color: AppColors.textPrimaryOf(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                match.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textPrimaryOf(context),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                match.skill,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                match.offering,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textSecondaryOf(context),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendingSkillTile extends StatelessWidget {
  const _TrendingSkillTile({required this.skill, required this.onTap});

  final _TrendingSkill skill;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    return Material(
      color: AppColors.surfaceOf(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderOf(context)),
        ),
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.isDark(context)
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.primarySoft,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.trending_up_rounded,
              color: AppColors.primary,
            ),
          ),
          title: Text(
            isArabic ? skill.nameAr : skill.name,
            style: TextStyle(
              color: AppColors.textPrimaryOf(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            isArabic ? skill.learnersAr : skill.learners,
            style: TextStyle(color: AppColors.textSecondaryOf(context), fontSize: 12),
          ),
          trailing: Icon(skill.icon, color: AppColors.iconOf(context)),
        ),
      ),
    );
  }
}

class _EmptySearchResult extends StatelessWidget {
  const _EmptySearchResult({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        message,
        style: TextStyle(color: AppColors.textSecondaryOf(context)),
      ),
    );
  }
}

class _SkillCategory {
  const _SkillCategory({
    required this.title,
    required this.titleAr,
    required this.subtitle,
    required this.subtitleAr,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  final String title;
  final String titleAr;
  final String subtitle;
  final String subtitleAr;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
}

class _MemberMatch {
  const _MemberMatch({
    required this.id,
    required this.name,
    required this.initials,
    required this.skill,
    required this.offering,
    required this.rating,
    required this.color,
  });

  final String id;
  final String name;
  final String initials;
  final String skill;
  final String offering;
  final String rating;
  final Color color;
}

class _TrendingSkill {
  const _TrendingSkill({
    required this.name,
    required this.nameAr,
    required this.learners,
    required this.learnersAr,
    required this.icon,
  });

  final String name;
  final String nameAr;
  final String learners;
  final String learnersAr;
  final IconData icon;
}
