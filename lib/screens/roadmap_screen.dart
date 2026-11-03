import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../models/skill_model.dart';
import '../providers/skill_provider.dart';
import 'detail_screen.dart';
class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  String selectedFilter = 'All';

  bool isSearching = false;

  final TextEditingController searchController =
      TextEditingController();

  final List<String> categories = [
    'All',
    'Programming',
    'DSA',
    'Frameworks',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String _getCategory(String skillName) {
    final name = skillName.toLowerCase().trim();

    if (name == 'dsa' ||
        name.contains('data structure') ||
        name.contains('algorithm')) {
      return 'DSA';
    }

    const frameworkNames = [
      'flutter',
      'react',
      'angular',
      'vue',
      'django',
      'spring',
      'express',
      'next.js',
    ];

    if (frameworkNames.any((framework) => name.contains(framework))) {
      return 'Frameworks';
    }

    return 'Programming';
  }

  void _toggleSearch() {
    setState(() {
      if (isSearching) {
        isSearching = false;
        searchController.clear();
        FocusScope.of(context).unfocus();
      } else {
        isSearching = true;
      }
    });
  }

  // LOADING STATE
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          SizedBox(height: 14),
          Text(
            'Loading your roadmaps...',
            style: TextStyle(
              color: AppColors.slateMedium,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ERROR STATE WITH RETRY
  Widget _buildErrorState(
    BuildContext context,
    String message,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.redAccent,
              size: 48,
            ),
            const SizedBox(height: 14),
            const Text(
              'Unable to Load Roadmaps',
              style: TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.slateMedium,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: () {
                context.read<SkillProvider>().loadSkills();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // EMPTY STATE
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.school_outlined,
            color: AppColors.grey,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.slateMedium,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 18,
                        color: AppColors.navy,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.maybePop(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Skill Roadmaps',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                IconButton(
                  icon: Icon(
                    isSearching ? Icons.close : Icons.search,
                    color: AppColors.black87,
                  ),
                  onPressed: _toggleSearch,
                ),
              ],
            ),

            // SEARCH FIELD
            if (isSearching) ...[
              const SizedBox(height: 8),
              TextField(
                controller: searchController,
                autofocus: true,
                onChanged: (_) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Search skills...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.cancel_outlined,
                            size: 19,
                          ),
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 12),

            // CATEGORY FILTERS
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  final isSelected = selectedFilter == category;

                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.white
                            : AppColors.black87,
                        fontSize: 12,
                      ),
                      backgroundColor: AppColors.white,
                      onSelected: (_) {
                        setState(() {
                          selectedFilter = category;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // FOUR MAIN SCREEN STATES
            Expanded(
              child: Consumer<SkillProvider>(
                builder: (context, skillProvider, child) {
                  // 1. LOADING
                  if (skillProvider.isLoading) {
                    return _buildLoadingState();
                  }

                  // 2. ERROR
                  if (skillProvider.errorMessage != null) {
                    return _buildErrorState(
                      context,
                      skillProvider.errorMessage!,
                    );
                  }

                  final allSkills = skillProvider.skills;

                  // 3. EMPTY
                  if (allSkills.isEmpty) {
                    return _buildEmptyState(
                      'No skills added yet.\n'
                      'Add your first skill to get started!',
                    );
                  }

                  // SEARCH AND FILTER
                  final query =
                      searchController.text.trim().toLowerCase();

                  final filteredSkills = allSkills.where((skill) {
                    final matchesCategory =
                        selectedFilter == 'All' ||
                        _getCategory(skill.title) == selectedFilter;

                    final matchesSearch =
                        query.isEmpty ||
                        skill.title.toLowerCase().contains(query) ||
                        skill.subtitle.toLowerCase().contains(query);

                    return matchesCategory && matchesSearch;
                  }).toList();

                  if (filteredSkills.isEmpty) {
                    return _buildEmptyState(
                      query.isNotEmpty
                          ? 'No skills found for "$query".'
                          : 'No skills available in $selectedFilter.',
                    );
                  }

                  // 4. DATA STATE
                  return ListView.builder(
                    itemCount: filteredSkills.length,
                    itemBuilder: (context, index) {
                      final skill = filteredSkills[index];

                      Color iconColor = AppColors.blue;
                      Color bgColor = AppColors.blue50;
                      IconData icon = Icons.code;

                      switch (skill.title.toLowerCase()) {
                        case 'python':
                          iconColor = AppColors.amberDark;
                          bgColor = AppColors.amberBackground;
                          icon = Icons.code;
                          break;

                        case 'java':
                          iconColor = AppColors.orangeDark;
                          bgColor = AppColors.orangeBackground;
                          icon = Icons.coffee;
                          break;

                        case 'dsa':
                          iconColor = AppColors.purple;
                          bgColor = AppColors.purpleBackground;
                          icon = Icons.account_tree;
                          break;

                        case 'flutter':
                          iconColor = AppColors.blue;
                          bgColor = AppColors.blue50;
                          icon = Icons.phone_android;
                          break;

                        case 'c':
                          iconColor = AppColors.indigo;
                          bgColor = AppColors.indigo50;
                          icon = Icons.terminal;
                          break;
                      }

                      return _buildRoadmapCard(
                        context,
                        skill.title,
                        skill.subtitle,
                        skill.progress,
                        iconColor,
                        icon,
                        bgColor,
                      );
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

  // ROADMAP CARD
  Widget _buildRoadmapCard(
    BuildContext context,
    String title,
    String subtitle,
    double progress,
    Color iconColor,
    IconData icon,
    Color bgCardColor,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              skill: Skill(
                title: title,
                subtitle: subtitle,
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.slateVeryLight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgCardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      minHeight: 5,
                      backgroundColor: AppColors.slateVeryLight,
                      color: iconColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right,
              color: AppColors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
