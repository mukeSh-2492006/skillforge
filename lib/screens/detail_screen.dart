import 'package:flutter/material.dart';
import '../models/skill_model.dart';

class DetailScreen extends StatelessWidget {
  final Skill skill;
  const DetailScreen({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(skill.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Roadmap: ${skill.subtitle}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Current Progress: ${(skill.progress * 100).toInt()}%', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}