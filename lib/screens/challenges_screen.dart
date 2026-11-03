import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../models/challenge_model.dart';
import '../providers/skill_provider.dart';
import '../widgets/add_challenge_dialog.dart';
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
      builder: (_) => const AddChallengeDialog(),
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
        backgroundColor: success ? AppColors.green : AppColors.red,
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
                        color: AppColors.primary,
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
                        color: completed ? AppColors.green : AppColors.orange,
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
          color: AppColors.transparent,
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
                          'Daily Challenges',
                          style: TextStyle(
                            color: AppColors.navy,
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
                            color: AppColors.primary,
                          ),
                          onPressed: _addChallenge,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: AppColors.navy,
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
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Today, $today',
                      style: TextStyle(
                        color: AppColors.greyDark,
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
                        AppColors.indigo100,
                        AppColors.indigo50,
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
                              color: AppColors.indigo400
                                  .withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.ads_click,
                              color: AppColors.indigo600,
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
                                  color: AppColors.indigo900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$completedCount of ${allChallenges.length} completed',
                                style: const TextStyle(
                                  color: AppColors.indigo500,
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
                        color: AppColors.indigo200,
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
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: selected
                                ? AppColors.white
                                : AppColors.slateDark,
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
        ? AppColors.green
        : challenge.difficulty == 'Medium'
            ? AppColors.orange
            : AppColors.red;

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
                color: AppColors.blue50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
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
                      _tag(challenge.category, AppColors.blue),
                      _tag(challenge.difficulty, badgeColor),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              completed ? Icons.check_circle : Icons.chevron_right,
              color: completed ? AppColors.green : AppColors.grey,
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
