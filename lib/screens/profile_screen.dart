import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/skill_provider.dart';
import 'add_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'help_support_screen.dart';
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
        backgroundColor: AppColors.green,
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
                      'Profile',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: AppColors.black87,
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
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      Icons.person,
                      color: AppColors.white,
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
                    'B.Tech $branch - $year',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
                  ),

                  if (college.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      college,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.grey,
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
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary,
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
                color: AppColors.blue50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.blue100,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.track_changes,
                    color: AppColors.primary,
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
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          learningGoal,
                          style: const TextStyle(
                            color: AppColors.grey,
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
                color: AppColors.navy,
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
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: AppColors.white,
                  side: const BorderSide(
                    color: AppColors.primary,
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
                color: AppColors.navy,
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
                  AppColors.green,
                  AppColors.greenBackground,
                ),
                _buildStatCard(
                  completedChallenges.toString(),
                  'Challenges Done',
                  Icons.emoji_events_outlined,
                  AppColors.amberDark,
                  AppColors.amberBackground,
                ),
                _buildStatCard(
                  totalSkills.toString(),
                  'Skills Added',
                  Icons.school_outlined,
                  AppColors.orange,
                  AppColors.orangeBackground,
                ),
                _buildStatCard(
                  '$progress%',
                  'Overall Progress',
                  Icons.bar_chart,
                  AppColors.blue,
                  AppColors.blue50,
                ),
                _buildStatCard(
                  '${provider.currentStreak} days',
                  'Current Streak',
                  Icons.local_fire_department,
                  AppColors.deepOrange,
                  AppColors.orangeBackground,
                ),
                _buildStatCard(
                  '${provider.longestStreak} days',
                  'Longest Streak',
                  Icons.emoji_events,
                  AppColors.amber,
                  AppColors.amberBackground,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ACHIEVEMENTS
            _profileNavTile(
              Icons.emoji_events_outlined,
              'My Achievements',
              AppColors.amber,
              AppColors.amberBackground,
              onTap: widget.onAchievementsTap,
            ),

            const SizedBox(height: 10),

            // SETTINGS
            _profileNavTile(
              Icons.settings_outlined,
              'Settings',
              AppColors.blue,
              AppColors.blue50,
              onTap: () => _openSettings(context),
            ),

            const SizedBox(height: 10),

            // HELP & SUPPORT
            _profileNavTile(
              Icons.help_outline,
              'Help & Support',
              AppColors.green,
              AppColors.greenBackground,
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
        return AppColors.amberDark;
      case 'java':
        return AppColors.orangeDark;
      case 'dsa':
        return AppColors.purple;
      case 'flutter':
        return AppColors.blue;
      default:
        return AppColors.primary;
    }
  }

  Color _getSkillBackground(String name) {
    switch (name.toLowerCase()) {
      case 'python':
        return AppColors.amberBackground;
      case 'java':
        return AppColors.orangeBackground;
      case 'dsa':
        return AppColors.purpleBackground;
      case 'flutter':
        return AppColors.blue50;
      default:
        return AppColors.blue100;
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.slateVeryLight,
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
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.grey,
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
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
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
                    color: AppColors.navy,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.grey,
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
