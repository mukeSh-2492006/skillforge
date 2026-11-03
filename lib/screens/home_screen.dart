import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../models/challenge_model.dart';
import '../providers/skill_provider.dart';
import 'challenges_screen.dart';
import 'roadmap_screen.dart';
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
                          color: AppColors.navy,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Learn Skills. Track Progress. Grow Together.',
                        style: TextStyle(
                          color: AppColors.slateMedium,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none_outlined,
                      color: AppColors.navy,
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
                    backgroundColor: AppColors.blue100,
                    child: Icon(
                      Icons.person,
                      color: AppColors.primary,
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
                          color: AppColors.navy,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Keep going! Your future self will\nthank you.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.slateMedium,
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
                  color: AppColors.blue50,
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
                            backgroundColor: AppColors.blue100,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '$percentage%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.navy,
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
                                    color: AppColors.navy,
                                  ),
                                ),
                              ),
                              Text(
                                '$completedTopics / $totalTopics',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.navy,
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
                              backgroundColor: AppColors.blue100,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Keep learning!',
                            style: TextStyle(
                              color: AppColors.primary,
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
                        color: AppColors.primary,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Today's Challenge",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _openChallenges(context),
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: AppColors.slateMedium,
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
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.slateVeryLight,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.blue50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        allChallengesCompleted
                            ? Icons.check_circle_outline
                            : Icons.code,
                        color: AppColors.primary,
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
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            allChallengesCompleted
                                ? 'Amazing! You completed all available challenges.'
                                : todayChallenge?.description ??
                                    'Explore challenges and start learning.',
                            style: const TextStyle(
                              color: AppColors.slateMedium,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => _openChallenges(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
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
                                    color: AppColors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 14,
                                  color: AppColors.white,
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
                        color: AppColors.primary,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Your Skills',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _openRoadmaps(context),
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: AppColors.slateMedium,
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
                          color: AppColors.blue50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'No skills added yet. Add your first skill in Roadmaps!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.slateMedium,
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
                              AppColors.blue50;
                          Color iconColor =
                              AppColors.primary;
                          IconData icon = Icons.school;

                          if (name.toLowerCase().contains('python')) {
                            bgColor = AppColors.amberBackground;
                            iconColor = AppColors.amberDark;
                            icon = Icons.code;
                          } else if (name.toLowerCase().contains('dsa')) {
                            bgColor = AppColors.purpleBackground;
                            iconColor = AppColors.purple;
                            icon = Icons.account_tree;
                          } else if (name.toLowerCase().contains('java')) {
                            bgColor = AppColors.orangeBackground;
                            iconColor = AppColors.orangeDark;
                            icon = Icons.coffee;
                          } else if (name.toLowerCase().contains('flutter')) {
                            bgColor = AppColors.skyBackground;
                            iconColor = AppColors.lightBlueDark;
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
                color: AppColors.white.withValues(alpha: 0.6),
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
                    color: AppColors.navy,
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
