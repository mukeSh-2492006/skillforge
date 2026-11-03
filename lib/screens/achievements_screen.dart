import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../models/achievement_badge.dart';
import '../providers/skill_provider.dart';
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

        final badges = <AchievementBadge>[
          // 1. LEARNING BADGES

          AchievementBadge(
            title: 'First Step',
            description: 'Complete your first topic',
            icon: Icons.military_tech,
            color: AppColors.amber,
            category: 'Learning',
            isUnlocked: completedTopics >= 1 ||
                completedChallenges >= 1,
          ),

          AchievementBadge(
            title: 'Topic Collector',
            description: 'Complete 5 topics',
            icon: Icons.collections_bookmark,
            color: AppColors.blue,
            category: 'Learning',
            isUnlocked: completedTopics >= 5,
          ),

          AchievementBadge(
            title: 'Knowledge Seeker',
            description: 'Complete 10 topics',
            icon: Icons.menu_book,
            color: AppColors.purple,
            category: 'Learning',
            isUnlocked: completedTopics >= 10,
          ),

          AchievementBadge(
            title: 'Learning Champion',
            description: 'Complete 25 topics',
            icon: Icons.school,
            color: AppColors.orange,
            category: 'Learning',
            isUnlocked: completedTopics >= 25,
          ),

          AchievementBadge(
            title: 'Roadmap Starter',
            description: 'Complete your first topic in any skill',
            icon: Icons.map,
            color: AppColors.teal,
            category: 'Learning',
            isUnlocked: activeSkills >= 1,
          ),

          // PYTHON

          AchievementBadge(
            title: 'Python Beginner',
            description: 'Complete 1 Python topic',
            icon: Icons.code,
            color: AppColors.purple,
            category: 'Learning',
            isUnlocked: completedForSkill('Python') >= 1,
          ),

          AchievementBadge(
            title: 'Python Explorer',
            description: 'Complete 5 Python topics',
            icon: Icons.explore,
            color: AppColors.deepPurple,
            category: 'Learning',
            isUnlocked: completedForSkill('Python') >= 5,
          ),

          AchievementBadge(
            title: 'Python Pro',
            description: 'Complete 10 Python topics',
            icon: Icons.terminal,
            color: AppColors.indigo,
            category: 'Learning',
            isUnlocked: completedForSkill('Python') >= 10,
          ),

          AchievementBadge(
            title: 'Python Master',
            description: 'Complete the entire Python roadmap',
            icon: Icons.workspace_premium,
            color: AppColors.amber,
            category: 'Learning',
            isUnlocked: fullyCompleted('Python'),
          ),

          // DSA

          AchievementBadge(
            title: 'DSA Starter',
            description: 'Complete 1 DSA topic',
            icon: Icons.account_tree,
            color: AppColors.green,
            category: 'Learning',
            isUnlocked: completedForSkill('DSA') >= 1,
          ),

          AchievementBadge(
            title: 'DSA Explorer',
            description: 'Complete 5 DSA topics',
            icon: Icons.hub,
            color: AppColors.teal,
            category: 'Learning',
            isUnlocked: completedForSkill('DSA') >= 5,
          ),

          AchievementBadge(
            title: 'Algorithm Master',
            description: 'Complete 10 DSA topics',
            icon: Icons.schema,
            color: AppColors.deepOrange,
            category: 'Learning',
            isUnlocked: completedForSkill('DSA') >= 10,
          ),

          // JAVA

          AchievementBadge(
            title: 'Java Beginner',
            description: 'Complete 1 Java topic',
            icon: Icons.coffee,
            color: AppColors.orange,
            category: 'Learning',
            isUnlocked: completedForSkill('Java') >= 1,
          ),

          AchievementBadge(
            title: 'Java Developer',
            description: 'Complete 5 Java topics',
            icon: Icons.developer_mode,
            color: AppColors.brown,
            category: 'Learning',
            isUnlocked: completedForSkill('Java') >= 5,
          ),

          AchievementBadge(
            title: 'Java Master',
            description: 'Complete the entire Java roadmap',
            icon: Icons.workspace_premium,
            color: AppColors.deepOrange,
            category: 'Learning',
            isUnlocked: fullyCompleted('Java'),
          ),

          // FLUTTER

          AchievementBadge(
            title: 'Flutter Beginner',
            description: 'Complete 1 Flutter topic',
            icon: Icons.phone_android,
            color: AppColors.blue,
            category: 'Learning',
            isUnlocked: completedForSkill('Flutter') >= 1,
          ),

          AchievementBadge(
            title: 'Widget Builder',
            description: 'Complete 3 Flutter topics',
            icon: Icons.widgets,
            color: AppColors.cyan,
            category: 'Learning',
            isUnlocked: completedForSkill('Flutter') >= 3,
          ),

          AchievementBadge(
            title: 'Flutter Developer',
            description: 'Complete 5 Flutter topics',
            icon: Icons.phonelink,
            color: AppColors.indigo,
            category: 'Learning',
            isUnlocked: completedForSkill('Flutter') >= 5,
          ),

          AchievementBadge(
            title: 'App Creator',
            description: 'Complete the entire Flutter roadmap',
            icon: Icons.apps,
            color: AppColors.teal,
            category: 'Learning',
            isUnlocked: fullyCompleted('Flutter'),
          ),

          // 2. CHALLENGE BADGES

          AchievementBadge(
            title: 'First Challenge',
            description: 'Complete your first challenge',
            icon: Icons.flag,
            color: AppColors.green,
            category: 'Challenges',
            isUnlocked: completedChallenges >= 1,
          ),

          AchievementBadge(
            title: 'Challenge Rookie',
            description: 'Complete 5 challenges',
            icon: Icons.stars,
            color: AppColors.orange,
            category: 'Challenges',
            isUnlocked: completedChallenges >= 5,
          ),

          AchievementBadge(
            title: 'Challenge Master',
            description: 'Complete 10 challenges',
            icon: Icons.emoji_events,
            color: AppColors.amber,
            category: 'Challenges',
            isUnlocked: completedChallenges >= 10,
          ),

          AchievementBadge(
            title: 'Challenge Expert',
            description: 'Complete 25 challenges',
            icon: Icons.military_tech,
            color: AppColors.deepPurple,
            category: 'Challenges',
            isUnlocked: completedChallenges >= 25,
          ),

          AchievementBadge(
            title: 'Code Ninja',
            description: 'Complete 50 challenges',
            icon: Icons.code,
            color: AppColors.purple,
            category: 'Challenges',
            isUnlocked: completedChallenges >= 50,
          ),

          AchievementBadge(
            title: 'Coding Solver',
            description: 'Complete 5 Coding challenges',
            icon: Icons.terminal,
            color: AppColors.teal,
            category: 'Challenges',
            isUnlocked: completedInCategory('Coding') >= 5,
          ),

          AchievementBadge(
            title: 'DSA Challenger',
            description: 'Complete 5 DSA challenges',
            icon: Icons.account_tree,
            color: AppColors.green,
            category: 'Challenges',
            isUnlocked: completedInCategory('DSA') >= 5,
          ),

          // 3. SPECIAL BADGES

          AchievementBadge(
            title: 'Roadmap Warrior',
            description: 'Complete one full roadmap',
            icon: Icons.map,
            color: AppColors.blue,
            category: 'Special',
            isUnlocked: completedRoadmaps >= 1,
          ),

          AchievementBadge(
            title: 'Skill Master',
            description: 'Complete 5 full roadmaps',
            icon: Icons.workspace_premium,
            color: AppColors.orange,
            category: 'Special',
            isUnlocked: completedRoadmaps >= 5,
          ),

          AchievementBadge(
            title: 'All-Rounder',
            description: 'Complete topics in 3 different skills',
            icon: Icons.stars,
            color: AppColors.purple,
            category: 'Special',
            isUnlocked: activeSkills >= 3,
          ),

          AchievementBadge(
            title: 'Placement Ready',
            description: 'Complete all your learning topics',
            icon: Icons.emoji_events,
            color: AppColors.green,
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
                          color: AppColors.navy,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Achievements',
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
                      Icons.share_outlined,
                      color: AppColors.black87,
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
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.slateVeryLight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: AppColors.amber,
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
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: unlockedCount / badges.length,
                        minHeight: 6,
                        backgroundColor:
                            AppColors.slateLight,
                        color: AppColors.primary,
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
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.white : AppColors.black87,
          fontSize: 12,
        ),
        backgroundColor: AppColors.white,
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.slateVeryLight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isUnlocked ? icon : Icons.lock_outline,
            color: isUnlocked ? color : AppColors.greyLight,
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
                  ? AppColors.navy
                  : AppColors.grey,
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
              color: AppColors.greyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
