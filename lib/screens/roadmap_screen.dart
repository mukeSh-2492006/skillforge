import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/skill_provider.dart';
import '../models/skill_model.dart';
import 'detail_screen.dart';

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  String selectedFilter = 'All';

  bool matchesFilter(Skill skill) {
    switch (selectedFilter) {
      case 'Programming':
        return ['python', 'java', 'c', 'c++', 'javascript']
            .contains(skill.title.toLowerCase());
      case 'DSA':
        return skill.title.toLowerCase() == 'dsa';
      case 'Frameworks':
        return ['flutter', 'react', 'angular', 'django']
            .contains(skill.title.toLowerCase());
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Skill Roadmaps',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Programming', 'DSA', 'Frameworks']
                    .map(
                      (filter) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: selectedFilter == filter,
                          onSelected: (_) {
                            setState(() {
                              selectedFilter = filter;
                            });
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<SkillProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(provider.errorMessage!),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: provider.loadSkills,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final skills = provider.skills
                      .where(matchesFilter)
                      .toList();

                  if (skills.isEmpty) {
                    return const Center(
                      child: Text(
                        'No skills found.\nAdd a skill to get started!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: skills.length,
                    itemBuilder: (context, index) {
                      final skill = skills[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: const Icon(
                            Icons.code,
                            color: Colors.blue,
                          ),
                          title: Text(
                            skill.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(skill.subtitle),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: skill.progress,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${(skill.progress * 100).round()}% completed',
                              ),
                              Text(
                                '${skill.completedTopics.length} of ${skill.topics.length} topics completed',
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(skill: skill),
                              ),
                            );
                          },
                        ),
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
}