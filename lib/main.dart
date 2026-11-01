import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/skill_model.dart';
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

// 1. HOME SCREEN (Wireframe 1 Pixel-Perfect Alignment)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
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
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, color: Color(0xFF1E293B), size: 24),
                onPressed: () {},
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
                child: Icon(Icons.person, color: Color(0xFF2563EB), size: 26),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Hi, Student!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Keep going! Your future self will\nthank you. 😉',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.2),
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
                  children: const [
                    SizedBox(
                      height: 64,
                      width: 64,
                      child: CircularProgressIndicator(
                        value: 0.40,
                        strokeWidth: 7,
                        backgroundColor: Color(0xFFDBEAFE),
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    Text(
                      '40%',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
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
                        children: const [
                          Text(
                            'Completed Topics',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                          ),
                          Text(
                            '12 / 30',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
                          value: 0.40,
                          minHeight: 7,
                          backgroundColor: Color(0xFFDBEAFE),
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Keep learning! 🚀',
                        style: TextStyle(color: Color(0xFF2563EB), fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
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
                  Icon(Icons.stars_outlined, color: Color(0xFF2563EB), size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Today's Challenge",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Today's Challenge Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.code, color: Color(0xFF2563EB), size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Solve a Coding Problem',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Find the missing number in an array.',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Start Now', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward, size: 14, color: Colors.white),
                          ],
                        ),
                      )
                    ],
                  ),
                )
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
                  Icon(Icons.handshake_outlined, color: Color(0xFF2563EB), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Your Skills',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Your Skills Cards Horizontal Scroll
          SizedBox(
            height: 115,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildSkillTile('Python', '40%', const Color(0xFFFEF3C7), Colors.amber.shade800, Icons.code),
                _buildSkillTile('DSA', '25%', const Color(0xFFF3E8FF), Colors.purple, Icons.account_tree),
                _buildSkillTile('Java', '15%', const Color(0xFFFFEDD5), Colors.orange.shade800, Icons.coffee),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget _buildSkillTile(String name, String progress, Color bgColor, Color iconColor, IconData icon) {
    return Container(
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
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
              const SizedBox(height: 2),
              Text(progress, style: TextStyle(color: iconColor, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}

// 2. ROADMAP SCREEN
class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        size: 18, color: Color(0xFF1E293B)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
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
                icon: const Icon(Icons.search, color: Colors.black87),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip('All', true),
                _buildChip('Programming', false),
                _buildChip('DSA', false),
                _buildChip('Frameworks', false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
  child: Consumer<SkillProvider>(
    builder: (context, skillProvider, child) {
      final skills = skillProvider.skills;

      return ListView.builder(
        itemCount: skills.length,
        itemBuilder: (context, index) {
          final skill = skills[index];

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
    );
  }

  Widget _buildChip(String label, bool isSelected) {
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
        onSelected: (_) {},
      ),
    );
  }

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
                progress: progress,
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
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgCardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
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
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: const Color(0xFFF1F5F9),
                      color: iconColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}

// 3. CHALLENGES SCREEN
class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF1E293B)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  const Text('Daily Challenges', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              IconButton(icon: const Icon(Icons.calendar_today_outlined, size: 20, color: Color(0xFF1E293B)), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_month, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text('Today, 14 Oct 2025', style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 90,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE0E7FF), Color(0xFFEEF2FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
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
                      decoration: BoxDecoration(color: const Color(0xFF818CF8).withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.ads_click, color: Color(0xFF4F46E5), size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Daily Challenge', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF312E81))),
                        SizedBox(height: 2),
                        Text('Consistency builds great skills!', style: TextStyle(color: Color(0xFF6366F1), fontSize: 11, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.topRight,
                  children: const [
                    Icon(Icons.terrain, size: 42, color: Color(0xFFA5B4FC)),
                    Positioned(right: 12, top: 2, child: Icon(Icons.flag, size: 16, color: Color(0xFF4F46E5)))
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', true),
                _buildFilterChip('Coding', false),
                _buildFilterChip('DSA', false),
                _buildFilterChip('Concepts', false),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView(
              children: [
                _buildChallengeItem('Solve the Two Sum Problem', 'Coding', 'Easy', Colors.green, Icons.code),
                _buildChallengeItem('Binary Search Implementation', 'DSA', 'Medium', Colors.orange, Icons.account_tree),
                _buildChallengeItem('OOP Concepts in Java', 'Concepts', 'Easy', Colors.green, Icons.coffee),
                _buildChallengeItem('Build a Simple Flutter App', 'Frameworks', 'Hard', Colors.red, Icons.phone_android),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: const Color(0xFF2563EB),
        labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xFF475569), fontSize: 12, fontWeight: FontWeight.w500),
        backgroundColor: Colors.white,
        side: BorderSide(color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0)),
        onSelected: (_) {},
      ),
    );
  }

  Widget _buildChallengeItem(String title, String category, String difficulty, Color badgeColor, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: const Color(0xFF2563EB), size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(6)),
                        child: Text(category, style: const TextStyle(color: Color(0xFF2563EB), fontSize: 10, fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: badgeColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                        child: Text(difficulty, style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}

// 4. PROGRESS SCREEN
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF1E293B)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  const Text('My Progress', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Row(
                  children: const [
                    Text('All Skills', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF334155))),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF334155)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F5F9))),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: const [
                          SizedBox(
                            height: 62,
                            width: 62,
                            child: CircularProgressIndicator(
                              value: 0.40,
                              strokeWidth: 6,
                              backgroundColor: Color(0xFFDBEAFE),
                              color: Color(0xFF2563EB),
                            ),
                          ),
                          Text('40%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Overall Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                            const SizedBox(height: 4),
                            const Text('12 of 30 topics completed', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: const LinearProgressIndicator(
                                value: 0.40,
                                minHeight: 6,
                                backgroundColor: Color(0xFFDBEAFE),
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Skill-wise Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
                const SizedBox(height: 12),
                _buildSkillProgressCard('Python', '8 / 14 topics', 0.57, Colors.amber.shade800, Icons.code, const Color(0xFFFEF3C7)),
                _buildSkillProgressCard('Java', '3 / 10 topics', 0.30, Colors.orange.shade800, Icons.coffee, const Color(0xFFFFEDD5)),
                _buildSkillProgressCard('DSA', '1 / 6 topics', 0.17, Colors.purple, Icons.account_tree, const Color(0xFFF3E8FF)),
                _buildSkillProgressCard('Flutter', '0 / 8 topics', 0.0, Colors.blue, Icons.phone_android, const Color(0xFFEFF6FF)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillProgressCard(String name, String sub, double val, Color color, IconData icon, Color iconBg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('${(val * 100).toInt()}%', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: val,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFF1F5F9),
                    color: color,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 5. ACHIEVEMENTS SCREEN
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF1E293B)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  const Text('Achievements', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              IconButton(icon: const Icon(Icons.share_outlined, color: Colors.black87, size: 20), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F5F9))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.emoji_events, color: Colors.amber, size: 24),
                    SizedBox(width: 10),
                    Text('Total Badges Earned', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('6 / 20', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(
                    value: 6 / 20,
                    minHeight: 6,
                    backgroundColor: Color(0xFFE2E8F0),
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip('All', true),
                _buildChip('Learning', false),
                _buildChip('Challenges', false),
                _buildChip('Special', false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
              children: [
                _buildBadgeItem('First Step', 'Completed your first challenge', Icons.military_tech, Colors.amber, true),
                _buildBadgeItem('Consistent Learner', '7 day streak', Icons.local_fire_department, Colors.orange, true),
                _buildBadgeItem('Python Beginner', 'Completed Python basics', Icons.code, Colors.purple, true),
                _buildBadgeItem('Challenge Master', '10 challenges completed', Icons.star, Colors.amber, true),
                _buildBadgeItem('DSA Explorer', 'Completed 5 DSA topics', Icons.account_tree, Colors.green, true),
                _buildBadgeItem('Roadmap Warrior', 'Completed 1 full roadmap', Icons.map, Colors.blue, true),
                _buildBadgeItem('Code Ninja', 'Complete 50 challenges', Icons.lock, Colors.grey, false),
                _buildBadgeItem('Skill Master', 'Complete 5 full roadmaps', Icons.lock, Colors.grey, false),
                _buildBadgeItem('Placement Ready', 'Achieve 100% readiness', Icons.lock, Colors.grey, false),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: const Color(0xFF2563EB),
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 12),
        backgroundColor: Colors.white,
        onSelected: (_) {},
      ),
    );
  }

  Widget _buildBadgeItem(String title, String desc, IconData icon, Color color, bool isUnlocked) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isUnlocked ? color : Colors.grey.shade400, size: 30),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: isUnlocked ? const Color(0xFF1E293B) : Colors.grey)),
          const SizedBox(height: 2),
          Text(desc, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

// 6. PROFILE SCREEN
class ProfileScreen extends StatelessWidget {
  final VoidCallback onAchievementsTap;
  const ProfileScreen({super.key, required this.onAchievementsTap});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF1E293B)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                const Text('Profile', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            IconButton(icon: const Icon(Icons.settings, color: Colors.black87, size: 20), onPressed: () {}),
          ],
        ),
        const SizedBox(height: 14),
        Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 36,
                backgroundColor: Color(0xFF2563EB),
                child: Icon(Icons.person, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 8),
              const Text('Mukesh', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              const Text('B.Tech CSE • 3rd Year', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 2),
              const Text('mukesh@example.com', style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFDBEAFE)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.track_changes, color: Color(0xFF2563EB), size: 22),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Learning Goals', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                      SizedBox(height: 2),
                      Text('Get placed in a top MNC', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.edit, size: 16, color: Color(0xFF2563EB)),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text('Selected Skills', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
        const SizedBox(height: 10),
       
             Wrap(
              spacing: 8,
             runSpacing: 8,
             children: [
             _buildSkillChip('Python', Colors.amber.shade800, const Color(0xFFFEF3C7)),
            _buildSkillChip('Java', Colors.orange.shade800, const Color(0xFFFFEDD5)),
            _buildSkillChip('DSA', Colors.purple, const Color(0xFFF3E8FF)),
            _buildSkillChip('Flutter', Colors.blue, const Color(0xFFEFF6FF)),
            ActionChip(
              label: const Text('+ Add Skill', style: TextStyle(color: Color(0xFF2563EB), fontSize: 12, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF2563EB)),
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => const AddScreen(),
    ),
  );
},
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text('My Stats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: [
            _buildStatCard('12', 'Topics Completed', Icons.check_circle_outline, Colors.green, const Color(0xFFDCFCE7)),
            _buildStatCard('6', 'Challenges Done', Icons.emoji_events_outlined, Colors.amber.shade800, const Color(0xFFFEF3C7)),
            _buildStatCard('5', 'Day Streak', Icons.local_fire_department_outlined, Colors.orange, const Color(0xFFFFEDD5)),
            _buildStatCard('40%', 'Overall Progress', Icons.bar_chart, Colors.blue, const Color(0xFFEFF6FF)),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onAchievementsTap,
          child: _profileNavTile(Icons.emoji_events_outlined, 'My Achievements', Colors.amber, const Color(0xFFFEF3C7)),
        ),
        const SizedBox(height: 10),
        _profileNavTile(Icons.settings_outlined, 'Settings', Colors.blue, const Color(0xFFEFF6FF)),
        const SizedBox(height: 10),
        _profileNavTile(Icons.help_outline, 'Help & Support', Colors.green, const Color(0xFFDCFCE7)),
      ],
    );
  }

  Widget _buildSkillChip(String label, Color textColor, Color bgColor) {
    return Chip(
      label: Text(label, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
      backgroundColor: bgColor,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
                const SizedBox(height: 2),
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileNavTile(IconData icon, String title, Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}