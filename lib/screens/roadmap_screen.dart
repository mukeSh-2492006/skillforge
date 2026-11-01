
import 'package:flutter/material.dart';
import '../models/skill_model.dart';
import 'detail_screen.dart';

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  String selectedFilter = 'All';

  final List<Skill> skills = [
    Skill(title: 'Python', subtitle: 'Beginner to Advanced', progress: 0.40),
    Skill(title: 'Java', subtitle: 'Beginner to Advanced', progress: 0.25),
    Skill(title: 'DSA', subtitle: 'Beginner to Advanced', progress: 0.15),
    Skill(title: 'Flutter', subtitle: 'Beginner to Advanced', progress: 0.10),
    Skill(title: 'C', subtitle: 'Beginner to Advanced', progress: 0.30),
  ];

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
                    .map((filter) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(filter),
                            selected: selectedFilter == filter,
                            onSelected: (_) {
                              setState(() => selectedFilter = filter);
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: skills.length,
                itemBuilder: (context, index) {
                  final skill = skills[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: const Icon(Icons.code, color: Colors.blue),
                      title: Text(
                        skill.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(skill.subtitle),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(value: skill.progress),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(skill: skill),
                          ),
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
  }
}

