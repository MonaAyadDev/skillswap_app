import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skillswap/core/constants/app_color.dart';
import 'package:skillswap/core/routes/routes.dart';

class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key});

  @override
  State<DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedSkill;
  String? _selectedCountry;

  static const List<_DiscoverMember> _members = [
    _DiscoverMember(
      id: 'alex-morgan',
      name: 'Alex Morgan',
      country: 'United States',
      bio: 'Product designer helping people turn ideas into intuitive apps.',
      teachSkills: ['UI/UX Design', 'Figma', 'Prototyping'],
      learnSkills: ['Photography', 'Illustration'],
      initials: 'AM',
      avatarColor: Color(0xFFE5D7CB),
      rating: 4.9,
    ),
    _DiscoverMember(
      id: 'jordan-lee',
      name: 'Jordan Lee',
      country: 'Canada',
      bio: 'Frontend developer who enjoys making the web accessible to all.',
      teachSkills: ['Web Development', 'JavaScript', 'HTML & CSS'],
      learnSkills: ['UI/UX Design', 'Public Speaking'],
      initials: 'JL',
      avatarColor: Color(0xFFD6E8E3),
      rating: 4.8,
    ),
    _DiscoverMember(
      id: 'sam-rivera',
      name: 'Sam Rivera',
      country: 'Spain',
      bio:
          'Photographer sharing practical tips for capturing everyday moments.',
      teachSkills: ['Photography', 'Photo Editing'],
      learnSkills: ['Spanish', 'Graphic Design'],
      initials: 'SR',
      avatarColor: Color(0xFFEBD9E8),
      rating: 5.0,
    ),
    _DiscoverMember(
      id: 'taylor-kim',
      name: 'Taylor Kim',
      country: 'South Korea',
      bio: 'Python developer and curious learner of creative skills.',
      teachSkills: ['Python', 'Data Analysis'],
      learnSkills: ['Digital Illustration', 'Korean'],
      initials: 'TK',
      avatarColor: Color(0xFFDCE1F5),
      rating: 4.7,
    ),
    _DiscoverMember(
      id: 'casey-patel',
      name: 'Casey Patel',
      country: 'United Kingdom',
      bio: 'Helping learners find their voice and speak with confidence.',
      teachSkills: ['Public Speaking', 'Writing'],
      learnSkills: ['Web Development', 'Photography'],
      initials: 'CP',
      avatarColor: Color(0xFFF3E3C8),
      rating: 4.9,
    ),
  ];

  static List<String> get _availableSkills {
    final skills = _members.expand((member) => member.teachSkills).toSet();
    return skills.toList()..sort();
  }

  static List<String> get _availableCountries {
    final countries = _members.map((member) => member.country).toSet();
    return countries.toList()..sort();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_DiscoverMember> get _filteredMembers {
    final query = _searchQuery.trim().toLowerCase();
    return _members.where((member) {
      final matchesQuery =
          query.isEmpty ||
          member.name.toLowerCase().contains(query) ||
          member.country.toLowerCase().contains(query) ||
          member.bio.toLowerCase().contains(query) ||
          member.teachSkills.any(
            (skill) => skill.toLowerCase().contains(query),
          ) ||
          member.learnSkills.any(
            (skill) => skill.toLowerCase().contains(query),
          );
      final matchesSkill =
          _selectedSkill == null || member.teachSkills.contains(_selectedSkill);
      final matchesCountry =
          _selectedCountry == null || member.country == _selectedCountry;
      return matchesQuery && matchesSkill && matchesCountry;
    }).toList();
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedSkill = null;
      _selectedCountry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                          const SizedBox(height: 8),
                          const Text(
                            'Find people to learn from and share what you know.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildSearchField(),
                          const SizedBox(height: 16),
                          _buildFilters(),
                          const SizedBox(height: 28),
                          _buildResultsHeader(),
                          const SizedBox(height: 14),
                          _buildResults(),
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
          child: Text(
            'Discover',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: () => context.go(AppRoutes.notifications),
          tooltip: 'Notifications',
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            fixedSize: const Size(48, 48),
          ),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _searchQuery = value),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search skills or people',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _searchQuery.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
                tooltip: 'Clear search',
                icon: const Icon(Icons.close_rounded),
              ),
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIconColor: AppColors.textMuted,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final fieldWidth = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: 12,
          children: [
            SizedBox(
              width: fieldWidth,
              child: _buildDropdown(
                label: 'Skill',
                hint: 'All skills',
                value: _selectedSkill,
                options: _availableSkills,
                onChanged: (value) => setState(() => _selectedSkill = value),
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: _buildDropdown(
                label: 'Country',
                hint: 'All countries',
                value: _selectedCountry,
                options: _availableCountries,
                onChanged: (value) => setState(() => _selectedCountry = value),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      hint: Text(hint, overflow: TextOverflow.ellipsis),
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text(hint, overflow: TextOverflow.ellipsis),
        ),
        ...options.map(
          (option) => DropdownMenuItem<String>(
            value: option,
            child: Text(option, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsHeader() {
    final results = _filteredMembers;
    final filtersApplied =
        _searchQuery.isNotEmpty ||
        _selectedSkill != null ||
        _selectedCountry != null;
    return Row(
      children: [
        Expanded(
          child: Text(
            'People to learn with',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          '${results.length} ${results.length == 1 ? 'person' : 'people'}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        if (filtersApplied) ...[
          const SizedBox(width: 6),
          TextButton(onPressed: _clearFilters, child: const Text('Clear')),
        ],
      ],
    );
  }

  Widget _buildResults() {
    final results = _filteredMembers;
    if (results.isEmpty) {
      return const _NoResults();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 14.0;
        final columns = constraints.maxWidth >= 680 ? 2 : 1;
        final cardWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: results
              .map(
                (member) => SizedBox(
                  width: cardWidth,
                  child: _MemberResultCard(
                    member: member,
                    onTap: () => context.go(
                      AppRoutes.userProfile.replaceFirst(':id', member.id),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _MemberResultCard extends StatelessWidget {
  const _MemberResultCard({required this.member, required this.onTap});

  final _DiscoverMember member;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: member.avatarColor,
                  child: Text(
                    member.initials,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 15,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              member.country,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFF2A93B),
                  size: 18,
                ),
                const SizedBox(width: 3),
                Text(
                  member.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              member.bio,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Can teach',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: member.teachSkills.take(3).map(_SkillChip.new).toList(),
            ),
            if (member.learnSkills.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Wants to learn',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: member.learnSkills
                    .take(2)
                    .map(_SkillChip.new)
                    .toList(),
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onTap,
                child: const Text('View profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, size: 40, color: AppColors.textMuted),
          SizedBox(height: 12),
          Text(
            'No matches found',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Try another search or adjust your filters.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _DiscoverMember {
  const _DiscoverMember({
    required this.id,
    required this.name,
    required this.country,
    required this.bio,
    required this.teachSkills,
    required this.learnSkills,
    required this.initials,
    required this.avatarColor,
    required this.rating,
  });

  final String id;
  final String name;
  final String country;
  final String bio;
  final List<String> teachSkills;
  final List<String> learnSkills;
  final String initials;
  final Color avatarColor;
  final double rating;
}
