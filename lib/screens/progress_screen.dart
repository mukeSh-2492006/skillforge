import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../providers/skill_provider.dart';
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
                          color: AppColors.navy,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'My Progress',
                        style: TextStyle(
                          color: AppColors.navy,
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
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.slateLight,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'All Skills',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: AppColors.slate,
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
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.slateVeryLight,
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
                                      AppColors.blue100,
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
                                    color: AppColors.navy,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$completedTopics of $totalTopics topics completed',
                                  style: const TextStyle(
                                    color: AppColors.grey,
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
                                        AppColors.blue100,
                                    color: AppColors.primary,
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
                        color: AppColors.navy,
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
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      ...skills.map((skill) {
                        Color color = AppColors.blue;
                        Color iconBg = AppColors.blue50;
                        IconData icon = Icons.code;

                        switch (skill.title.toLowerCase()) {
                          case 'python':
                            color = AppColors.amberDark;
                            iconBg = AppColors.amberBackground;
                            icon = Icons.code;
                            break;

                          case 'java':
                            color = AppColors.orangeDark;
                            iconBg = AppColors.orangeBackground;
                            icon = Icons.coffee;
                            break;

                          case 'dsa':
                            color = AppColors.purple;
                            iconBg = AppColors.purpleBackground;
                            icon = Icons.account_tree;
                            break;

                          case 'flutter':
                            color = AppColors.blue;
                            iconBg = AppColors.blue50;
                            icon = Icons.phone_android;
                            break;

                          case 'c':
                            color = AppColors.indigo;
                            iconBg = AppColors.indigo50;
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
                    color: AppColors.grey,
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
                        AppColors.slateVeryLight,
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
