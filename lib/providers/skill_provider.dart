import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/skill_model.dart';

class SkillProvider extends ChangeNotifier {
  final List<Skill> _skills = [
    Skill(
      title: 'Python',
      subtitle: 'Beginner to Advanced',
      progress: 0.40,
    ),
    Skill(
      title: 'Java',
      subtitle: 'Beginner to Advanced',
      progress: 0.25,
    ),
    Skill(
      title: 'DSA',
      subtitle: 'Beginner to Advanced',
      progress: 0.15,
    ),
    Skill(
      title: 'Flutter',
      subtitle: 'Beginner to Advanced',
      progress: 0.10,
    ),
    Skill(
        title: 'C', 
        subtitle: 'Beginner to Advanced',
        progress: 0.30
    ),
  ];

  List<Skill> get skills => List.unmodifiable(_skills);

  Future<void> loadSkills() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSkills = prefs.getStringList('custom_skills') ?? [];

    for (final title in savedSkills) {
      if (!_skills.any(
        (skill) => skill.title.toLowerCase() == title.toLowerCase(),
      )) {
        _skills.add(
          Skill(
            title: title,
            subtitle: 'Beginner to Advanced',
            progress: 0.0,
          ),
        );
      }
    }

    notifyListeners();
  }

  Future<void> addSkill(String title) async {
    final cleanTitle = title.trim();

    if (cleanTitle.isEmpty) return;

    if (_skills.any(
      (skill) => skill.title.toLowerCase() == cleanTitle.toLowerCase(),
    )) {
      return;
    }

    _skills.add(
      Skill(
        title: cleanTitle,
        subtitle: 'Beginner to Advanced',
        progress: 0.0,
      ),
    );

    final prefs = await SharedPreferences.getInstance();

    final savedSkills = prefs.getStringList('custom_skills') ?? [];
    savedSkills.add(cleanTitle);

    await prefs.setStringList('custom_skills', savedSkills);

    notifyListeners();
  }
}