import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/di/service_locator.dart';
import 'package:skillswap/core/localization/app_translations.dart';
import 'package:skillswap/core/models/match_model.dart';
import 'package:skillswap/core/routes/routes.dart';
import '../cubit/matches_cubit.dart';
import '../cubit/matches_state.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MatchesCubit>(),
      child: const _MatchesView(),
    );
  }
}

class _MatchesView extends StatefulWidget {
  const _MatchesView();

  @override
  State<_MatchesView> createState() => _MatchesViewState();
}

class _MatchesViewState extends State<_MatchesView> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Design',
    'Tech',
    'Photography',
    'Languages',
    'Speaking',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOf(context),
        elevation: 0,
        title: Text(
          context.tr('smart_matches'),
          style: TextStyle(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Banner
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('mutual_affinity'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.tr('mutual_desc'),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => context.read<MatchesCubit>().setSearchQuery(val),
                style: TextStyle(color: AppColors.textPrimaryOf(context)),
                decoration: InputDecoration(
                  hintText: context.isArabic
                      ? 'ابحث عن مرشدين متوافقين أو مهارات...'
                      : 'Search matching mentors or skills...',
                  hintStyle: TextStyle(color: AppColors.textMutedOf(context)),
                  prefixIcon: Icon(Icons.search, color: AppColors.textMutedOf(context)),
                  filled: true,
                  fillColor: AppColors.surfaceOf(context),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.borderOf(context)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.borderOf(context)),
                  ),
                ),
              ),
            ),

            // Categories Filter Pills
            BlocBuilder<MatchesCubit, MatchesState>(
              builder: (context, state) {
                return SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = (state.filterCategory == null && cat == 'All') ||
                          state.filterCategory == cat;

                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) {
                          context.read<MatchesCubit>().setFilterCategory(cat == 'All' ? null : cat);
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surfaceOf(context),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimaryOf(context),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            // Matches List
            Expanded(
              child: BlocBuilder<MatchesCubit, MatchesState>(
                builder: (context, state) {
                  final list = state.filteredMatches;

                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMutedOf(context)),
                          const SizedBox(height: 12),
                          Text(
                            context.isArabic ? 'لم يتم العثور على توافقات مطابقة' : 'No matching profiles found',
                            style: TextStyle(
                              color: AppColors.textSecondaryOf(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final match = list[index];
                      return _MatchItemCard(match: match);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchItemCard extends StatelessWidget {
  final MatchModel match;

  const _MatchItemCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final initials = match.partnerName
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderOf(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.isDark(context)
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : AppColors.primarySoft,
                    child: Text(
                      initials.isNotEmpty ? initials : 'P',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.online,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
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
                    Text(
                      match.partnerName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryOf(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      match.partnerSkill,
                      style: TextStyle(
                        color: AppColors.textSecondaryOf(context),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, size: 14, color: AppColors.success),
                    const SizedBox(width: 2),
                    Text(
                      '${match.matchPercentage}% ${context.isArabic ? "توافق" : "Match"}',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Skills badge preview
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoftOf(context),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.swap_horiz_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    match.skillsExchanged.join('  ⇄  '),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryOf(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.push(
                      AppRoutes.skillRequest,
                      extra: {
                        'userId': match.userIds.firstWhere((id) => id != 'current_user', orElse: () => 'alex-morgan'),
                        'userName': match.partnerName,
                        'teachSkills': match.skillsExchanged,
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(Icons.swap_calls_rounded, size: 17),
                  label: Text(context.tr('swap_request')),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push(AppRoutes.chat.replaceFirst(':matchId', match.id));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                  label: Text(context.tr('chat')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
