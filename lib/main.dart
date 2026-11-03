import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';

import 'providers/skill_provider.dart';
import 'screens/challenges_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/achievements_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/home_screen.dart';
import 'screens/roadmap_screen.dart';

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
      theme: AppTheme.lightTheme,
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
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
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
// 3. CHALLENGES SCREEN

// 4. PROGRESS SCREEN

// 5. ACHIEVEMENTS SCREEN

// 6. PROFILE SCREEN
