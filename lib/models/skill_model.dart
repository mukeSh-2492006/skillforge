class Skill {
  final String title;
  final String subtitle;
  final List<String> topics;
  final List<String> completedTopics;

  Skill({
    required this.title,
    required this.subtitle,
    this.topics = const [],
    this.completedTopics = const [],
  });

  // Calculate progress automatically
  double get progress {
    if (topics.isEmpty) return 0.0;

    return completedTopics.length / topics.length;
  }

  // Create updated Skill when a topic is completed
  Skill copyWith({
    String? title,
    String? subtitle,
    List<String>? topics,
    List<String>? completedTopics,
  }) {
    return Skill(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      topics: topics ?? this.topics,
      completedTopics: completedTopics ?? this.completedTopics,
    );
  }

  // Convert Skill into JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'topics': topics,
      'completedTopics': completedTopics,
    };
  }

  // Create Skill from saved JSON
  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      topics: List<String>.from(json['topics'] ?? []),
      completedTopics:
          List<String>.from(json['completedTopics'] ?? []),
    );
  }
}