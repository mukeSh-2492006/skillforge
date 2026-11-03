import 'package:flutter/material.dart';
class AchievementBadge {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String category;
  final bool isUnlocked;

  const AchievementBadge({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
    required this.isUnlocked,
  });
}
