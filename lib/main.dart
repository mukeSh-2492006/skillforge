import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/skill_model.dart';
import 'models/challenge_model.dart';
import 'screens/detail_screen.dart';
import 'providers/skill_provider.dart';
import 'screens/add_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SkillProvider()..loadSkills(),
      child: const SkillSprintApp(),
    ),
  );
}

class SkillSprintApp extends StatelessWidget {
  const SkillSprintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillSprint',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0; // Defaulting to Home Screen (Wireframe 1)

  void navigateToAchievements() {
    setState(() {
      selectedIndex = 4; // Switch to Achievements screen
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      const RoadmapScreen(),
      const ChallengesScreen(),
      const ProgressScreen(),
      const AchievementsScreen(),
      ProfileScreen(onAchievementsTap: navigateToAchievements),
    ];

    return Scaffold(
      body: SafeArea(
        child: screens[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex > 4 ? 5 : selectedIndex,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Roadmaps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ads_click_outlined),
            activeIcon: Icon(Icons.ads_click),
            label: 'Challenges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            activeIcon: Icon(Icons.emoji_events),
            label: 'Badges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// 1. HOME SCREEN - Dynamic Data with Existing Design
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openChallenges(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChallengesScreen(),
      ),
    );
  }

  void _openRoadmaps(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoadmapScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SkillProvider>(
      builder: (context, provider, child) {
        final progress = provider.overallProgress.clamp(0.0, 1.0);
        final percentage = (progress * 100).round();

        final totalTopics = provider.totalTopics;
        final completedTopics = provider.completedTopics;

        final challenges = provider.challenges;

        Challenge? todayChallenge;

        for (final challenge in challenges) {
          if (!provider.isChallengeCompleted(challenge.id)) {
            todayChallenge = challenge;
            break;
          }
        }

        final allChallengesCompleted = challenges.isNotEmpty &&
            challenges.every(
              (challenge) => provider.isChallengeCompleted(challenge.id),
            );

        todayChallenge ??= challenges.isNotEmpty ? challenges.first : null;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'SkillSprint',
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Learn Skills. Track Progress. Grow Together.',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none_outlined,
                      color: Color(0xFF1E293B),
                      size: 24,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No new notifications yet.'),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // User Welcome Row
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFFDBEAFE),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF2563EB),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Hi, Student!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Keep going! Your future self will\nthank you. 😉',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Overall Progress Box
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 64,
                          width: 64,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 7,
                            backgroundColor: const Color(0xFFDBEAFE),
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        Text(
                          '$percentage%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text(
                                  'Completed Topics',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                              Text(
                                '$completedTopics / $totalTopics',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 7,
                              backgroundColor: const Color(0xFFDBEAFE),
                              color: const Color(0xFF2563EB),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Keep learning! 🚀',
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Today's Challenge Title Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.stars_outlined,
                        color: Color(0xFF2563EB),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Today's Challenge",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _openChallenges(context),
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Dynamic Today's Challenge Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFF1F5F9),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        allChallengesCompleted
                            ? Icons.check_circle_outline
                            : Icons.code,
                        color: const Color(0xFF2563EB),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todayChallenge?.title ??
                                'No challenges available',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            allChallengesCompleted
                                ? 'Amazing! You completed all available challenges.'
                                : todayChallenge?.description ??
                                    'Explore challenges and start learning.',
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => _openChallenges(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  allChallengesCompleted
                                      ? 'View Challenges'
                                      : 'Start Now',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Your Skills Title Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.handshake_outlined,
                        color: Color(0xFF2563EB),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Your Skills',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _openRoadmaps(context),
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Dynamic Skills Cards
              SizedBox(
                height: 115,
                child: provider.skills.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'No skills added yet. Add your first skill in Roadmaps!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.skills.length,
                        itemBuilder: (context, index) {
                          final skill = provider.skills[index];
                          final name = skill.title;
                          final skillProgress =
                              (skill.progress * 100).round();

                          Color bgColor =
                              const Color(0xFFEFF6FF);
                          Color iconColor =
                              const Color(0xFF2563EB);
                          IconData icon = Icons.school;

                          if (name.toLowerCase().contains('python')) {
                            bgColor = const Color(0xFFFEF3C7);
                            iconColor = Colors.amber.shade800;
                            icon = Icons.code;
                          } else if (name.toLowerCase().contains('dsa')) {
                            bgColor = const Color(0xFFF3E8FF);
                            iconColor = Colors.purple;
                            icon = Icons.account_tree;
                          } else if (name.toLowerCase().contains('java')) {
                            bgColor = const Color(0xFFFFEDD5);
                            iconColor = Colors.orange.shade800;
                            icon = Icons.coffee;
                          } else if (name.toLowerCase().contains('flutter')) {
                            bgColor = const Color(0xFFE0F2FE);
                            iconColor = Colors.lightBlue.shade800;
                            icon = Icons.phone_android;
                          }

                          return _buildSkillTile(
                            name,
                            '$skillProgress%',
                            bgColor,
                            iconColor,
                            icon,
                            () => _openRoadmaps(context),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildSkillTile(
    String name,
    String progress,
    Color bgColor,
    Color iconColor,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 115,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  progress,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 2. ROADMAP SCREEN

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
            color: Color(0xFF2563EB),
          ),
          SizedBox(height: 14),
          Text(
            'Loading your roadmaps...',
            style: TextStyle(
              color: Color(0xFF64748B),
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
              color: Colors.redAccent,
              size: 48,
            ),
            const SizedBox(height: 14),
            const Text(
              'Unable to Load Roadmaps',
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF64748B),
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
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
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
            color: Colors.grey,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF64748B),
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
      color: Colors.transparent,
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
                        color: Color(0xFF1E293B),
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
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                IconButton(
                  icon: Icon(
                    isSearching ? Icons.close : Icons.search,
                    color: Colors.black87,
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
                    color: Color(0xFF2563EB),
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
                  fillColor: Colors.white,
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
                      selectedColor: const Color(0xFF2563EB),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.black87,
                        fontSize: 12,
                      ),
                      backgroundColor: Colors.white,
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

                      Color iconColor = Colors.blue;
                      Color bgColor = const Color(0xFFEFF6FF);
                      IconData icon = Icons.code;

                      switch (skill.title.toLowerCase()) {
                        case 'python':
                          iconColor = Colors.amber.shade800;
                          bgColor = const Color(0xFFFEF3C7);
                          icon = Icons.code;
                          break;

                        case 'java':
                          iconColor = Colors.orange.shade800;
                          bgColor = const Color(0xFFFFEDD5);
                          icon = Icons.coffee;
                          break;

                        case 'dsa':
                          iconColor = Colors.purple;
                          bgColor = const Color(0xFFF3E8FF);
                          icon = Icons.account_tree;
                          break;

                        case 'flutter':
                          iconColor = Colors.blue;
                          bgColor = const Color(0xFFEFF6FF);
                          icon = Icons.phone_android;
                          break;

                        case 'c':
                          iconColor = Colors.indigo;
                          bgColor = const Color(0xFFEEF2FF);
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFF1F5F9),
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
                          color: Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      minHeight: 5,
                      backgroundColor: const Color(0xFFF1F5F9),
                      color: iconColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// 3. CHALLENGES SCREEN

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  String selectedFilter = 'All';

  final List<String> categories = [
    'All',
    'Coding',
    'DSA',
    'Python',
    'Java',
    'Flutter',
    'Concepts',
  ];

  Future<void> _addChallenge() async {
    final data = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const _AddChallengeDialog(),
    );

    if (!mounted || data == null) return;

    final success = await context.read<SkillProvider>().addCustomChallenge(
          title: data['title']!,
          category: data['category']!,
          difficulty: data['difficulty']!,
          description: data['description']!,
        );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Challenge added successfully!'
              : 'Challenge already exists or is invalid.',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _openChallenge(Challenge challenge) async {
    final provider = context.read<SkillProvider>();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        bool saving = false;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final completed =
                provider.isChallengeCompleted(challenge.id);

            return AlertDialog(
              title: Text(challenge.title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.category,
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Difficulty: ${challenge.difficulty}'),
                    const SizedBox(height: 18),
                    const Text(
                      'Challenge Details',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(challenge.description),
                    const SizedBox(height: 18),
                    Text(
                      completed ? 'Completed' : 'Not Completed',
                      style: TextStyle(
                        color: completed ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: saving
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: saving
                      ? null
                      : () async {
                          setDialogState(() {
                            saving = true;
                          });

                          final success =
                              await provider.toggleChallengeCompletion(
                            challenge.id,
                          );

                          if (!dialogContext.mounted) return;

                          Navigator.pop(dialogContext, success);
                        },
                  child: saving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          completed
                              ? 'Mark Incomplete'
                              : 'Mark Completed',
                        ),
                ),
              ],
            );
          },
        );
      },
    );

    if (!mounted || result == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result
              ? 'Challenge status updated!'
              : 'Unable to update challenge.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SkillProvider>(
      builder: (context, provider, child) {
        final allChallenges = provider.challenges;

        final visibleChallenges = allChallenges.where((challenge) {
          return selectedFilter == 'All' ||
              challenge.category == selectedFilter;
        }).toList();

        final completedCount = provider.completedChallengesCount;

        final now = DateTime.now();

        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
        ];

        final today = '${now.day} ${months[now.month - 1]} ${now.year}';

        // MATERIAL FIX:
        // ChoiceChip and InkWell need a Material ancestor.
        return Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 18,
                            color: Color(0xFF1E293B),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            Navigator.maybePop(context);
                          },
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Daily Challenges',
                          style: TextStyle(
                            color: Color(0xFF1E293B),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Add your own challenge',
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Color(0xFF2563EB),
                          ),
                          onPressed: _addChallenge,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: Color(0xFF1E293B),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Today\'s challenges'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Today, $today',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Daily Challenge Banner
                Container(
                  height: 90,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFE0E7FF),
                        Color(0xFFEEF2FF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF818CF8)
                                  .withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.ads_click,
                              color: Color(0xFF4F46E5),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Daily Challenge',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF312E81),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$completedCount of ${allChallenges.length} completed',
                                style: const TextStyle(
                                  color: Color(0xFF6366F1),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.terrain,
                        size: 42,
                        color: Color(0xFFA5B4FC),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Category Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      final selected = selectedFilter == category;

                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: selected,
                          selectedColor: const Color(0xFF2563EB),
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : const Color(0xFF475569),
                            fontSize: 12,
                          ),
                          backgroundColor: Colors.white,
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

                const SizedBox(height: 14),

                // Dynamic Challenge List
                Expanded(
                  child: visibleChallenges.isEmpty
                      ? const Center(
                          child: Text(
                            'No challenges in this category.',
                          ),
                        )
                      : ListView.builder(
                          itemCount: visibleChallenges.length,
                          itemBuilder: (context, index) {
                            final challenge = visibleChallenges[index];

                            final completed =
                                provider.isChallengeCompleted(
                              challenge.id,
                            );

                            return _buildChallengeCard(
                              challenge,
                              completed,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChallengeCard(
    Challenge challenge,
    bool completed,
  ) {
    final Color badgeColor = challenge.difficulty == 'Easy'
        ? Colors.green
        : challenge.difficulty == 'Medium'
            ? Colors.orange
            : Colors.red;

    final IconData icon = challenge.category == 'DSA'
        ? Icons.account_tree
        : challenge.category == 'Java'
            ? Icons.coffee
            : challenge.category == 'Flutter'
                ? Icons.phone_android
                : Icons.code;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openChallenge(challenge),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFF1F5F9),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF2563EB),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _tag(challenge.category, Colors.blue),
                      _tag(challenge.difficulty, badgeColor),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              completed ? Icons.check_circle : Icons.chevron_right,
              color: completed ? Colors.green : Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


// ADD CHALLENGE DIALOG

class _AddChallengeDialog extends StatefulWidget {
  const _AddChallengeDialog();

  @override
  State<_AddChallengeDialog> createState() =>
      _AddChallengeDialogState();
}

class _AddChallengeDialogState extends State<_AddChallengeDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  String _category = 'Coding';
  String _difficulty = 'Easy';

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _category,
        'difficulty': _difficulty,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Your Challenge'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                maxLength: 60,
                decoration: const InputDecoration(
                  labelText: 'Challenge Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 3) {
                    return 'Enter at least 3 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  'Coding',
                  'DSA',
                  'Python',
                  'Java',
                  'Flutter',
                  'Concepts',
                ].map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _category = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: _difficulty,
                decoration: const InputDecoration(
                  labelText: 'Difficulty',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  'Easy',
                  'Medium',
                  'Hard',
                ].map((difficulty) {
                  return DropdownMenuItem<String>(
                    value: difficulty,
                    child: Text(difficulty),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _difficulty = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _descriptionController,
                maxLength: 500,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 10) {
                    return 'Enter at least 10 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Add Challenge'),
        ),
      ],
    );
  }
}

// 4. PROGRESS SCREEN

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SkillProvider>(
      builder: (context, provider, child) {
        final skills = provider.skills;
        final totalTopics = provider.totalTopics;
        final completedTopics = provider.completedTopics;
        final overallProgress = provider.overallProgress;
        final percentage = (overallProgress * 100).toInt();

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 18,
                          color: Color(0xFF1E293B),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'My Progress',
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'All Skills',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF334155),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: Color(0xFF334155),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView(
                  children: [
                    // Overall Progress Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFF1F5F9),
                        ),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 62,
                                width: 62,
                                child: CircularProgressIndicator(
                                  value: overallProgress,
                                  strokeWidth: 6,
                                  backgroundColor:
                                      const Color(0xFFDBEAFE),
                                  color: const Color(0xFF2563EB),
                                ),
                              ),
                              Text(
                                '$percentage%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Overall Progress',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$completedTopics of $totalTopics topics completed',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: overallProgress,
                                    minHeight: 6,
                                    backgroundColor:
                                        const Color(0xFFDBEAFE),
                                    color: const Color(0xFF2563EB),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Skill-wise Progress',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF1E293B),
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (skills.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Text(
                            'No skills added yet.\n'
                            'Add a skill to track your progress.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      ...skills.map((skill) {
                        Color color = Colors.blue;
                        Color iconBg = const Color(0xFFEFF6FF);
                        IconData icon = Icons.code;

                        switch (skill.title.toLowerCase()) {
                          case 'python':
                            color = Colors.amber.shade800;
                            iconBg = const Color(0xFFFEF3C7);
                            icon = Icons.code;
                            break;

                          case 'java':
                            color = Colors.orange.shade800;
                            iconBg = const Color(0xFFFFEDD5);
                            icon = Icons.coffee;
                            break;

                          case 'dsa':
                            color = Colors.purple;
                            iconBg = const Color(0xFFF3E8FF);
                            icon = Icons.account_tree;
                            break;

                          case 'flutter':
                            color = Colors.blue;
                            iconBg = const Color(0xFFEFF6FF);
                            icon = Icons.phone_android;
                            break;

                          case 'c':
                            color = Colors.indigo;
                            iconBg = const Color(0xFFEEF2FF);
                            icon = Icons.terminal;
                            break;
                        }

                        return _buildSkillProgressCard(
                          skill.title,
                          '${skill.completedTopics.length} / ${skill.topics.length} topics',
                          skill.progress,
                          color,
                          icon,
                          iconBg,
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkillProgressCard(
    String name,
    String subtitle,
    double progress,
    Color color,
    IconData icon,
    Color iconBg,
  ) {
    final percentage = (progress * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
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
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 6),

                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor:
                        const Color(0xFFF1F5F9),
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 5. ACHIEVEMENTS SCREEN

class _AchievementBadge {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String category;
  final bool isUnlocked;

  const _AchievementBadge({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
    required this.isUnlocked,
  });
}

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() =>
      _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Consumer<SkillProvider>(
      builder: (context, provider, child) {
        final skills = provider.skills;

        final completedTopics = provider.completedTopics;
        final totalTopics = provider.totalTopics;
        final completedChallenges =
            provider.completedChallengesCount;

        int completedForSkill(String name) {
          return skills
              .where(
                (skill) =>
                    skill.title.toLowerCase() ==
                    name.toLowerCase(),
              )
              .fold(
                0,
                (sum, skill) =>
                    sum + skill.completedTopics.length,
              );
        }

        bool fullyCompleted(String name) {
          return skills.any(
            (skill) =>
                skill.title.toLowerCase() == name.toLowerCase() &&
                skill.topics.isNotEmpty &&
                skill.completedTopics.length ==
                    skill.topics.length,
          );
        }

        int completedInCategory(String category) {
          return provider.challenges.where((challenge) {
            return challenge.category.toLowerCase() ==
                    category.toLowerCase() &&
                provider.isChallengeCompleted(challenge.id);
          }).length;
        }

        final completedRoadmaps = skills.where((skill) {
          return skill.topics.isNotEmpty &&
              skill.completedTopics.length ==
                  skill.topics.length;
        }).length;

        final activeSkills = skills.where((skill) {
          return skill.completedTopics.isNotEmpty;
        }).length;

        final badges = <_AchievementBadge>[
          // 1. LEARNING BADGES

          _AchievementBadge(
            title: 'First Step',
            description: 'Complete your first topic',
            icon: Icons.military_tech,
            color: Colors.amber,
            category: 'Learning',
            isUnlocked: completedTopics >= 1 ||
                completedChallenges >= 1,
          ),

          _AchievementBadge(
            title: 'Topic Collector',
            description: 'Complete 5 topics',
            icon: Icons.collections_bookmark,
            color: Colors.blue,
            category: 'Learning',
            isUnlocked: completedTopics >= 5,
          ),

          _AchievementBadge(
            title: 'Knowledge Seeker',
            description: 'Complete 10 topics',
            icon: Icons.menu_book,
            color: Colors.purple,
            category: 'Learning',
            isUnlocked: completedTopics >= 10,
          ),

          _AchievementBadge(
            title: 'Learning Champion',
            description: 'Complete 25 topics',
            icon: Icons.school,
            color: Colors.orange,
            category: 'Learning',
            isUnlocked: completedTopics >= 25,
          ),

          _AchievementBadge(
            title: 'Roadmap Starter',
            description: 'Complete your first topic in any skill',
            icon: Icons.map,
            color: Colors.teal,
            category: 'Learning',
            isUnlocked: activeSkills >= 1,
          ),

          // PYTHON

          _AchievementBadge(
            title: 'Python Beginner',
            description: 'Complete 1 Python topic',
            icon: Icons.code,
            color: Colors.purple,
            category: 'Learning',
            isUnlocked: completedForSkill('Python') >= 1,
          ),

          _AchievementBadge(
            title: 'Python Explorer',
            description: 'Complete 5 Python topics',
            icon: Icons.explore,
            color: Colors.deepPurple,
            category: 'Learning',
            isUnlocked: completedForSkill('Python') >= 5,
          ),

          _AchievementBadge(
            title: 'Python Pro',
            description: 'Complete 10 Python topics',
            icon: Icons.terminal,
            color: Colors.indigo,
            category: 'Learning',
            isUnlocked: completedForSkill('Python') >= 10,
          ),

          _AchievementBadge(
            title: 'Python Master',
            description: 'Complete the entire Python roadmap',
            icon: Icons.workspace_premium,
            color: Colors.amber,
            category: 'Learning',
            isUnlocked: fullyCompleted('Python'),
          ),

          // DSA

          _AchievementBadge(
            title: 'DSA Starter',
            description: 'Complete 1 DSA topic',
            icon: Icons.account_tree,
            color: Colors.green,
            category: 'Learning',
            isUnlocked: completedForSkill('DSA') >= 1,
          ),

          _AchievementBadge(
            title: 'DSA Explorer',
            description: 'Complete 5 DSA topics',
            icon: Icons.hub,
            color: Colors.teal,
            category: 'Learning',
            isUnlocked: completedForSkill('DSA') >= 5,
          ),

          _AchievementBadge(
            title: 'Algorithm Master',
            description: 'Complete 10 DSA topics',
            icon: Icons.schema,
            color: Colors.deepOrange,
            category: 'Learning',
            isUnlocked: completedForSkill('DSA') >= 10,
          ),

          // JAVA

          _AchievementBadge(
            title: 'Java Beginner',
            description: 'Complete 1 Java topic',
            icon: Icons.coffee,
            color: Colors.orange,
            category: 'Learning',
            isUnlocked: completedForSkill('Java') >= 1,
          ),

          _AchievementBadge(
            title: 'Java Developer',
            description: 'Complete 5 Java topics',
            icon: Icons.developer_mode,
            color: Colors.brown,
            category: 'Learning',
            isUnlocked: completedForSkill('Java') >= 5,
          ),

          _AchievementBadge(
            title: 'Java Master',
            description: 'Complete the entire Java roadmap',
            icon: Icons.workspace_premium,
            color: Colors.deepOrange,
            category: 'Learning',
            isUnlocked: fullyCompleted('Java'),
          ),

          // FLUTTER

          _AchievementBadge(
            title: 'Flutter Beginner',
            description: 'Complete 1 Flutter topic',
            icon: Icons.phone_android,
            color: Colors.blue,
            category: 'Learning',
            isUnlocked: completedForSkill('Flutter') >= 1,
          ),

          _AchievementBadge(
            title: 'Widget Builder',
            description: 'Complete 3 Flutter topics',
            icon: Icons.widgets,
            color: Colors.cyan,
            category: 'Learning',
            isUnlocked: completedForSkill('Flutter') >= 3,
          ),

          _AchievementBadge(
            title: 'Flutter Developer',
            description: 'Complete 5 Flutter topics',
            icon: Icons.phonelink,
            color: Colors.indigo,
            category: 'Learning',
            isUnlocked: completedForSkill('Flutter') >= 5,
          ),

          _AchievementBadge(
            title: 'App Creator',
            description: 'Complete the entire Flutter roadmap',
            icon: Icons.apps,
            color: Colors.teal,
            category: 'Learning',
            isUnlocked: fullyCompleted('Flutter'),
          ),

          // 2. CHALLENGE BADGES

          _AchievementBadge(
            title: 'First Challenge',
            description: 'Complete your first challenge',
            icon: Icons.flag,
            color: Colors.green,
            category: 'Challenges',
            isUnlocked: completedChallenges >= 1,
          ),

          _AchievementBadge(
            title: 'Challenge Rookie',
            description: 'Complete 5 challenges',
            icon: Icons.stars,
            color: Colors.orange,
            category: 'Challenges',
            isUnlocked: completedChallenges >= 5,
          ),

          _AchievementBadge(
            title: 'Challenge Master',
            description: 'Complete 10 challenges',
            icon: Icons.emoji_events,
            color: Colors.amber,
            category: 'Challenges',
            isUnlocked: completedChallenges >= 10,
          ),

          _AchievementBadge(
            title: 'Challenge Expert',
            description: 'Complete 25 challenges',
            icon: Icons.military_tech,
            color: Colors.deepPurple,
            category: 'Challenges',
            isUnlocked: completedChallenges >= 25,
          ),

          _AchievementBadge(
            title: 'Code Ninja',
            description: 'Complete 50 challenges',
            icon: Icons.code,
            color: Colors.purple,
            category: 'Challenges',
            isUnlocked: completedChallenges >= 50,
          ),

          _AchievementBadge(
            title: 'Coding Solver',
            description: 'Complete 5 Coding challenges',
            icon: Icons.terminal,
            color: Colors.teal,
            category: 'Challenges',
            isUnlocked: completedInCategory('Coding') >= 5,
          ),

          _AchievementBadge(
            title: 'DSA Challenger',
            description: 'Complete 5 DSA challenges',
            icon: Icons.account_tree,
            color: Colors.green,
            category: 'Challenges',
            isUnlocked: completedInCategory('DSA') >= 5,
          ),

          // 3. SPECIAL BADGES

          _AchievementBadge(
            title: 'Roadmap Warrior',
            description: 'Complete one full roadmap',
            icon: Icons.map,
            color: Colors.blue,
            category: 'Special',
            isUnlocked: completedRoadmaps >= 1,
          ),

          _AchievementBadge(
            title: 'Skill Master',
            description: 'Complete 5 full roadmaps',
            icon: Icons.workspace_premium,
            color: Colors.orange,
            category: 'Special',
            isUnlocked: completedRoadmaps >= 5,
          ),

          _AchievementBadge(
            title: 'All-Rounder',
            description: 'Complete topics in 3 different skills',
            icon: Icons.stars,
            color: Colors.purple,
            category: 'Special',
            isUnlocked: activeSkills >= 3,
          ),

          _AchievementBadge(
            title: 'Placement Ready',
            description: 'Complete all your learning topics',
            icon: Icons.emoji_events,
            color: Colors.green,
            category: 'Special',
            isUnlocked: totalTopics > 0 &&
                completedTopics == totalTopics,
          ),
        ];

        final unlockedCount =
            badges.where((badge) => badge.isUnlocked).length;

        final visibleBadges = badges.where((badge) {
          return selectedFilter == 'All' ||
              badge.category == selectedFilter;
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 18,
                          color: Color(0xFF1E293B),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Achievements',
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.share_outlined,
                      color: Colors.black87,
                      size: 20,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Total badges card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFF1F5F9),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Total Badges Earned',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '$unlockedCount / ${badges.length}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),

                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: unlockedCount / badges.length,
                        minHeight: 6,
                        backgroundColor:
                            const Color(0xFFE2E8F0),
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChip('All'),
                    _buildChip('Learning'),
                    _buildChip('Challenges'),
                    _buildChip('Special'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Badge grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: visibleBadges.map((badge) {
                    return _buildBadgeItem(
                      badge.title,
                      badge.description,
                      badge.icon,
                      badge.color,
                      badge.isUnlocked,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(String label) {
    final isSelected = selectedFilter == label;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: const Color(0xFF2563EB),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontSize: 12,
        ),
        backgroundColor: Colors.white,
        onSelected: (_) {
          setState(() {
            selectedFilter = label;
          });
        },
      ),
    );
  }

  Widget _buildBadgeItem(
    String title,
    String desc,
    IconData icon,
    Color color,
    bool isUnlocked,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isUnlocked ? icon : Icons.lock_outline,
            color: isUnlocked ? color : Colors.grey.shade400,
            size: 30,
          ),

          const SizedBox(height: 8),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: isUnlocked
                  ? const Color(0xFF1E293B)
                  : Colors.grey,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            desc,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

// 6. PROFILE SCREEN

class ProfileScreen extends StatefulWidget {
  final VoidCallback onAchievementsTap;

  const ProfileScreen({
    super.key,
    required this.onAchievementsTap,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String studentName = 'Student';
  String branch = 'CSE';
  String year = '3rd Year';
  String college = '';
  String learningGoal = 'Get placed in a top MNC';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // LOAD SAVED PROFILE
  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!mounted) return;

      setState(() {
        studentName = prefs.getString('profile_name') ?? 'Student';
        branch = prefs.getString('profile_branch') ?? 'CSE';
        year = prefs.getString('profile_year') ?? '3rd Year';
        college = prefs.getString('profile_college') ?? '';
        learningGoal = prefs.getString('profile_goal') ??
            'Get placed in a top MNC';
      });
    } catch (_) {
      // Keep default profile details if loading fails.
    }
  }

  // OPEN EDIT PROFILE
  Future<void> _editProfile() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          initialName: studentName,
          initialBranch: branch,
          initialYear: year,
          initialCollege: college,
          initialGoal: learningGoal,
        ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      studentName = result['name']!;
      branch = result['branch']!;
      year = result['year']!;
      college = result['college']!;
      learningGoal = result['goal']!;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
      ),
    );
  }

  void _openHelpSupport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HelpSupportScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SkillProvider>(
      builder: (context, provider, child) {
        final completedTopics = provider.completedTopics;
        final completedChallenges =
            provider.completedChallengesCount;
        final totalSkills = provider.skills.length;
        final progress = (provider.overallProgress * 100).toInt();

        return ListView(
          padding: const EdgeInsets.all(16.0),
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
                        color: Color(0xFF1E293B),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.maybePop(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black87,
                    size: 20,
                  ),
                  onPressed: () => _openSettings(context),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // USER PROFILE
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: Color(0xFF2563EB),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    studentName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'B.Tech $branch • $year',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),

                  if (college.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      college,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),

                  OutlinedButton.icon(
                    onPressed: _editProfile,
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 16,
                    ),
                    label: const Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      side: const BorderSide(
                        color: Color(0xFF2563EB),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // LEARNING GOAL
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFDBEAFE),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.track_changes,
                    color: Color(0xFF2563EB),
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Learning Goals',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          learningGoal,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // SELECTED SKILLS
            const Text(
              'Selected Skills',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF1E293B),
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...provider.skills.map((skill) {
                  return _buildSkillChip(
                    skill.title,
                    _getSkillColor(skill.title),
                    _getSkillBackground(skill.title),
                  );
                }),

                ActionChip(
                  label: const Text(
                    '+ Add Skill',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0xFF2563EB),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 18),

            // MY STATS
            const Text(
              'My Stats',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF1E293B),
              ),
            ),

            const SizedBox(height: 10),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: [
                _buildStatCard(
                  completedTopics.toString(),
                  'Topics Completed',
                  Icons.check_circle_outline,
                  Colors.green,
                  const Color(0xFFDCFCE7),
                ),
                _buildStatCard(
                  completedChallenges.toString(),
                  'Challenges Done',
                  Icons.emoji_events_outlined,
                  Colors.amber.shade800,
                  const Color(0xFFFEF3C7),
                ),
                _buildStatCard(
                  totalSkills.toString(),
                  'Skills Added',
                  Icons.school_outlined,
                  Colors.orange,
                  const Color(0xFFFFEDD5),
                ),
                _buildStatCard(
                  '$progress%',
                  'Overall Progress',
                  Icons.bar_chart,
                  Colors.blue,
                  const Color(0xFFEFF6FF),
                ),
                _buildStatCard(
                  '${provider.currentStreak} days',
                  'Current Streak',
                  Icons.local_fire_department,
                  Colors.deepOrange,
                  const Color(0xFFFFEDD5),
                ),
                _buildStatCard(
                  '${provider.longestStreak} days',
                  'Longest Streak',
                  Icons.emoji_events,
                  Colors.amber,
                  const Color(0xFFFEF3C7),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ACHIEVEMENTS
            _profileNavTile(
              Icons.emoji_events_outlined,
              'My Achievements',
              Colors.amber,
              const Color(0xFFFEF3C7),
              onTap: widget.onAchievementsTap,
            ),

            const SizedBox(height: 10),

            // SETTINGS
            _profileNavTile(
              Icons.settings_outlined,
              'Settings',
              Colors.blue,
              const Color(0xFFEFF6FF),
              onTap: () => _openSettings(context),
            ),

            const SizedBox(height: 10),

            // HELP & SUPPORT
            _profileNavTile(
              Icons.help_outline,
              'Help & Support',
              Colors.green,
              const Color(0xFFDCFCE7),
              onTap: () => _openHelpSupport(context),
            ),
          ],
        );
      },
    );
  }

  Color _getSkillColor(String name) {
    switch (name.toLowerCase()) {
      case 'python':
        return Colors.amber.shade800;
      case 'java':
        return Colors.orange.shade800;
      case 'dsa':
        return Colors.purple;
      case 'flutter':
        return Colors.blue;
      default:
        return const Color(0xFF2563EB);
    }
  }

  Color _getSkillBackground(String name) {
    switch (name.toLowerCase()) {
      case 'python':
        return const Color(0xFFFEF3C7);
      case 'java':
        return const Color(0xFFFFEDD5);
      case 'dsa':
        return const Color(0xFFF3E8FF);
      case 'flutter':
        return const Color(0xFFEFF6FF);
      default:
        return const Color(0xFFDBEAFE);
    }
  }

  Widget _buildSkillChip(
    String label,
    Color textColor,
    Color bgColor,
  ) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: bgColor,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileNavTile(
    IconData icon,
    String title,
    Color iconColor,
    Color bgColor, {
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFF1F5F9),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// EDIT PROFILE SCREEN

class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialBranch;
  final String initialYear;
  final String initialCollege;
  final String initialGoal;

  const EditProfileScreen({
    super.key,
    required this.initialName,
    required this.initialBranch,
    required this.initialYear,
    required this.initialCollege,
    required this.initialGoal,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _collegeController;
  late final TextEditingController _goalController;

  final List<String> branches = [
    'CSE',
    'CSE (AI&ML)',
    'CSE (Data Science)',
    'IT',
    'ECE',
    'EEE',
    'Mechanical',
    'Civil',
    'Other',
  ];

  final List<String> years = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];

  late String selectedBranch;
  late String selectedYear;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.initialName == 'Student'
          ? ''
          : widget.initialName,
    );

    _collegeController = TextEditingController(
      text: widget.initialCollege,
    );

    _goalController = TextEditingController(
      text: widget.initialGoal,
    );

    selectedBranch = branches.contains(widget.initialBranch)
        ? widget.initialBranch
        : 'Other';

    selectedYear = years.contains(widget.initialYear)
        ? widget.initialYear
        : '3rd Year';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _collegeController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  // SAVE PROFILE
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSaving = true;
    });

    final name = _nameController.text.trim();
    final college = _collegeController.text.trim();
    final goal = _goalController.text.trim();

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('profile_name', name);
      await prefs.setString('profile_branch', selectedBranch);
      await prefs.setString('profile_year', selectedYear);
      await prefs.setString('profile_college', college);
      await prefs.setString('profile_goal', goal);

      if (!mounted) return;

      Navigator.pop(
        context,
        {
          'name': name,
          'branch': selectedBranch,
          'year': selectedYear,
          'college': college,
          'goal': goal,
        },
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to save profile. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF1E293B),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Center(
              child: CircleAvatar(
                radius: 38,
                backgroundColor: Color(0xFFDBEAFE),
                child: Icon(
                  Icons.person,
                  color: Color(0xFF2563EB),
                  size: 42,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // NAME
            const Text(
              'Full Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _nameController,
              maxLength: 40,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }

                if (value.trim().length < 2) {
                  return 'Name must contain at least 2 characters';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            // BRANCH
            const Text(
              'Branch',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: selectedBranch,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.school_outlined),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: branches.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: isSaving
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          selectedBranch = value;
                        });
                      }
                    },
            ),

            const SizedBox(height: 20),

            // YEAR
            const Text(
              'Year of Study',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: selectedYear,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.calendar_today_outlined,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: years.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: isSaving
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          selectedYear = value;
                        });
                      }
                    },
            ),

            const SizedBox(height: 20),

            // COLLEGE
            const Text(
              'College Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _collegeController,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: 'Enter your college name',
                prefixIcon: const Icon(
                  Icons.account_balance_outlined,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // LEARNING GOAL
            const Text(
              'Learning Goal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _goalController,
              maxLength: 100,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'What is your learning goal?',
                prefixIcon: const Icon(Icons.track_changes),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your learning goal';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            // SAVE BUTTON
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Save Profile',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 8. SETTINGS SCREEN

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool remindersEnabled = false;
  bool isLoading = true;

  static const String reminderKey =
      'skill_sprint_reminders_enabled';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!mounted) return;

      setState(() {
        remindersEnabled = prefs.getBool(reminderKey) ?? false;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateReminders(bool value) async {
    setState(() {
      remindersEnabled = value;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(reminderKey, value);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings preference saved successfully!'),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        remindersEnabled = !value;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to save settings.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF1E293B),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2563EB),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Preferences',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(
                      color: Color(0xFFF1F5F9),
                    ),
                  ),
                  child: SwitchListTile(
                    value: remindersEnabled,
                    activeThumbColor: const Color(0xFF2563EB),
                    secondary: const CircleAvatar(
                      backgroundColor: Color(0xFFEFF6FF),
                      child: Icon(
                        Icons.notifications_active_outlined,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    title: const Text(
                      'Learning Reminders',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: const Text(
                      'Save your reminder preference.',
                      style: TextStyle(fontSize: 12),
                    ),
                    onChanged: _updateReminders,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Text(
                    'This stores your preference on this device. '
                    'Automatic notification scheduling is not configured yet.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'About',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(
                      color: Color(0xFFF1F5F9),
                    ),
                  ),
                  child: const ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFFEFF6FF),
                      child: Icon(
                        Icons.school_outlined,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    title: Text(
                      'SkillSprint',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      'Learn Skills. Track Progress. Grow Together.',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// 9. HELP AND SUPPORT SCREEN

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Widget _buildFaq(String question, String answer) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(
          color: Color(0xFFF1F5F9),
        ),
      ),
      child: ExpansionTile(
        iconColor: const Color(0xFF2563EB),
        collapsedIconColor: Colors.grey,
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Color(0xFF1E293B),
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF1E293B),
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.support_agent,
                  size: 36,
                  color: Color(0xFF2563EB),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How can we help?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Find answers to common questions about SkillSprint.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),

          const SizedBox(height: 12),

          _buildFaq(
            'How do I add a new skill?',
            'Open Roadmaps and use the Add Skill option.',
          ),

          _buildFaq(
            'How can I track my learning progress?',
            'Open Progress or Profile to see completed topics and overall progress.',
          ),

          _buildFaq(
            'How do I complete a challenge?',
            'Open Challenges, select a challenge and tap Mark Completed.',
          ),

          _buildFaq(
            'How can I earn achievements?',
            'Complete roadmap topics and challenges to unlock achievements.',
          ),

          _buildFaq(
            'Will my learning data remain saved?',
            'SkillSprint saves your learning data locally on your device using SharedPreferences.',
          ),

          const SizedBox(height: 18),

          const Text(
            'Need More Help?',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(
                color: Color(0xFFF1F5F9),
              ),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFDCFCE7),
                child: Icon(
                  Icons.contact_support_outlined,
                  color: Colors.green,
                ),
              ),
              title: const Text(
                'Contact Support',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              subtitle: const Text(
                'Get help with an app issue.',
                style: TextStyle(fontSize: 11),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: const Text('Contact Support'),
                      content: const Text(
                        'For help with SkillSprint, contact your '
                        'project mentor or app development team. '
                        'Share a screenshot and describe the issue.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: const Text('Got it'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}