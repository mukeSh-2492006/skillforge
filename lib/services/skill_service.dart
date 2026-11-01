import '../models/skill_model.dart';

class SkillService {
  List<Skill> getSkills() {
    return [
      Skill(title: 'Python', subtitle: 'Beginner to Advanced', progress: 0.40),
      Skill(title: 'Java', subtitle: 'Beginner to Advanced', progress: 0.25),
      Skill(title: 'DSA', subtitle: 'Beginner to Advanced', progress: 0.15),
      Skill(title: 'Flutter', subtitle: 'Beginner to Advanced', progress: 0.10),
    ];
  }
}