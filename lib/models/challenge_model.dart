class Challenge {
  final String id;
  final String title;
  final String category;
  final String difficulty;
  final String description;

  const Challenge({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'difficulty': difficulty,
      'description': description,
    };
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? 'Coding',
      difficulty: json['difficulty'] ?? 'Easy',
      description: json['description'] ?? '',
    );
  }
}