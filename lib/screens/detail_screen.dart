import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/skill_model.dart';
import '../providers/skill_provider.dart';
import '../widgets/add_topic_dialog.dart';

class DetailScreen extends StatelessWidget {
  final Skill skill;

  const DetailScreen({
    super.key,
    required this.skill,
  });

  Future<void> _showAddTopicDialog(
    BuildContext context,
    String skillTitle,
  ) async {
    final topic = await showDialog<String>(
      context: context,
      builder: (context) => const AddTopicDialog(),
    );

    if (!context.mounted || topic == null) return;

    final success = await context
        .read<SkillProvider>()
        .addTopic(skillTitle, topic);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Topic added successfully!'
              : 'Topic already exists or is invalid.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SkillProvider>(
      builder: (context, provider, child) {
        final currentSkill = provider.skills.firstWhere(
          (item) => item.title == skill.title,
          orElse: () => skill,
        );

        final progress = currentSkill.progress;

        return Scaffold(
          appBar: AppBar(
            title: Text(currentSkill.title),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddTopicDialog(
              context,
              currentSkill.title,
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Topic'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Roadmap: ${currentSkill.subtitle}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Current Progress: ${(progress * 100).toInt()}%',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Learning Topics',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: currentSkill.topics.isEmpty
                      ? const Center(
                          child: Text(
                            'No topics added yet.\n'
                            'Tap + Add Topic to get started.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: currentSkill.topics.length,
                          itemBuilder: (context, index) {
                            final topic = currentSkill.topics[index];

                            final isCompleted = currentSkill
                                .completedTopics
                                .contains(topic);

                            return Card(
                              child: CheckboxListTile(
                                value: isCompleted,
                                title: Text(topic),
                                subtitle: Text(
                                  isCompleted
                                      ? 'Completed'
                                      : 'Not completed',
                                ),
                                onChanged: (value) {
                                  provider.toggleTopicCompletion(
                                    currentSkill.title,
                                    topic,
                                  );
                                },
                              ),
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
}
