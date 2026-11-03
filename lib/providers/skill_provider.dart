import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/skill_model.dart';
import '../models/challenge_model.dart';

// 30 Built-in Challenges
const List<Challenge> builtInChallenges = [
  // CODING
  Challenge(
    id: 'coding_01',
    title: 'Solve the Two Sum Problem',
    category: 'Coding',
    difficulty: 'Easy',
    description: 'Find two numbers in an array whose sum equals a given target.',
  ),
  Challenge(
    id: 'coding_02',
    title: 'Reverse a String',
    category: 'Coding',
    difficulty: 'Easy',
    description: 'Write a program to reverse a given string.',
  ),
  Challenge(
    id: 'coding_03',
    title: 'Check Palindrome',
    category: 'Coding',
    difficulty: 'Easy',
    description: 'Check whether a given word or string is a palindrome.',
  ),
  Challenge(
    id: 'coding_04',
    title: 'Find the Largest Number',
    category: 'Coding',
    difficulty: 'Easy',
    description: 'Find the largest element in an array.',
  ),
  Challenge(
    id: 'coding_05',
    title: 'Count Character Frequency',
    category: 'Coding',
    difficulty: 'Medium',
    description: 'Count how many times each character appears in a string.',
  ),
  Challenge(
    id: 'coding_06',
    title: 'Find Missing Number',
    category: 'Coding',
    difficulty: 'Medium',
    description: 'Find the missing number in a sequence of integers.',
  ),

  // DSA
  Challenge(
    id: 'dsa_01',
    title: 'Binary Search Implementation',
    category: 'DSA',
    difficulty: 'Medium',
    description: 'Implement binary search on a sorted array.',
  ),
  Challenge(
    id: 'dsa_02',
    title: 'Implement Bubble Sort',
    category: 'DSA',
    difficulty: 'Easy',
    description: 'Sort an array using bubble sort.',
  ),
  Challenge(
    id: 'dsa_03',
    title: 'Implement a Stack',
    category: 'DSA',
    difficulty: 'Medium',
    description: 'Implement push, pop and peek operations.',
  ),
  Challenge(
    id: 'dsa_04',
    title: 'Implement a Queue',
    category: 'DSA',
    difficulty: 'Medium',
    description: 'Create a queue with enqueue and dequeue operations.',
  ),
  Challenge(
    id: 'dsa_05',
    title: 'Factorial Using Recursion',
    category: 'DSA',
    difficulty: 'Easy',
    description: 'Calculate factorial using recursion.',
  ),
  Challenge(
    id: 'dsa_06',
    title: 'Merge Two Sorted Arrays',
    category: 'DSA',
    difficulty: 'Hard',
    description: 'Merge two sorted arrays into one sorted array.',
  ),

  // PYTHON
  Challenge(
    id: 'python_01',
    title: 'Python Variables and Data Types',
    category: 'Python',
    difficulty: 'Easy',
    description: 'Practise different Python data types.',
  ),
  Challenge(
    id: 'python_02',
    title: 'Python List Operations',
    category: 'Python',
    difficulty: 'Easy',
    description: 'Practise adding, removing and accessing list elements.',
  ),
  Challenge(
    id: 'python_03',
    title: 'Dictionary Frequency Counter',
    category: 'Python',
    difficulty: 'Medium',
    description: 'Use a dictionary to count element frequency.',
  ),
  Challenge(
    id: 'python_04',
    title: 'Create Python Functions',
    category: 'Python',
    difficulty: 'Easy',
    description: 'Write reusable functions with parameters and return values.',
  ),
  Challenge(
    id: 'python_05',
    title: 'Python File Handling',
    category: 'Python',
    difficulty: 'Medium',
    description: 'Read data from a file and write results into another file.',
  ),

  // JAVA
  Challenge(
    id: 'java_01',
    title: 'OOP Concepts in Java',
    category: 'Java',
    difficulty: 'Easy',
    description: 'Understand the four pillars of object-oriented programming.',
  ),
  Challenge(
    id: 'java_02',
    title: 'Java Inheritance',
    category: 'Java',
    difficulty: 'Medium',
    description: 'Create parent and child classes using inheritance.',
  ),
  Challenge(
    id: 'java_03',
    title: 'Java Exception Handling',
    category: 'Java',
    difficulty: 'Medium',
    description: 'Practise try, catch and finally.',
  ),
  Challenge(
    id: 'java_04',
    title: 'Java Collections',
    category: 'Java',
    difficulty: 'Medium',
    description: 'Practise ArrayList, HashSet and HashMap.',
  ),
  Challenge(
    id: 'java_05',
    title: 'Java Interface',
    category: 'Java',
    difficulty: 'Hard',
    description: 'Create and implement an interface in Java.',
  ),

  // FLUTTER
  Challenge(
    id: 'flutter_01',
    title: 'Build a Simple Flutter App',
    category: 'Flutter',
    difficulty: 'Easy',
    description: 'Create an app using Flutter widgets and layouts.',
  ),
  Challenge(
    id: 'flutter_02',
    title: 'Create a Reusable Widget',
    category: 'Flutter',
    difficulty: 'Medium',
    description: 'Build a reusable custom widget.',
  ),
  Challenge(
    id: 'flutter_03',
    title: 'Flutter Navigation',
    category: 'Flutter',
    difficulty: 'Medium',
    description: 'Navigate between screens using Navigator.',
  ),
  Challenge(
    id: 'flutter_04',
    title: 'Create a Validated Form',
    category: 'Flutter',
    difficulty: 'Medium',
    description: 'Build a form with TextFormField validation.',
  ),
  Challenge(
    id: 'flutter_05',
    title: 'Save Data Locally',
    category: 'Flutter',
    difficulty: 'Hard',
    description: 'Save and retrieve data using SharedPreferences.',
  ),

  // CONCEPTS
  Challenge(
    id: 'concept_01',
    title: 'Understand Operating Systems',
    category: 'Concepts',
    difficulty: 'Easy',
    description: 'Learn processes, threads and memory management.',
  ),
  Challenge(
    id: 'concept_02',
    title: 'Database Normalization',
    category: 'Concepts',
    difficulty: 'Medium',
    description: 'Understand 1NF, 2NF and 3NF.',
  ),
  Challenge(
    id: 'concept_03',
    title: 'Computer Networks Basics',
    category: 'Concepts',
    difficulty: 'Medium',
    description: 'Learn IP addresses, DNS, HTTP and networking layers.',
  ),
];

class SkillProvider extends ChangeNotifier {
  List<Skill> _skills = [];

  List<Challenge> _customChallenges = [];

  Set<String> _completedChallengeIds = {};

  // DAILY STREAK DATA
  int _currentStreak = 0;
  int _longestStreak = 0;
  DateTime? _lastActivityDate;

  static const String _lastActivityKey = 'last_activity_date';
  static const String _currentStreakKey = 'current_streak';
  static const String _longestStreakKey = 'longest_streak';

  bool isLoading = false;
  String? errorMessage;

  List<Skill> get skills => List.unmodifiable(_skills);

  List<Challenge> get challenges => List.unmodifiable([
        ...builtInChallenges,
        ..._customChallenges,
      ]);

  // STREAK GETTERS
  int get currentStreak => _currentStreak;

  int get longestStreak => _longestStreak;

  String get lastActivityDate {
    if (_lastActivityDate == null) return 'No activity yet';

    return _dateKey(_lastActivityDate!);
  }

  bool get studiedToday {
    return _isSameDay(_lastActivityDate, DateTime.now());
  }

  int get completedChallengesCount {
    return challenges
        .where((challenge) =>
            _completedChallengeIds.contains(challenge.id))
        .length;
  }

  bool isChallengeCompleted(String challengeId) {
    return _completedChallengeIds.contains(challengeId);
  }

  int get totalTopics => _skills.fold(
        0,
        (sum, skill) => sum + skill.topics.length,
      );

  int get completedTopics => _skills.fold(
        0,
        (sum, skill) => sum + skill.completedTopics.length,
      );

  double get overallProgress {
    if (totalTopics == 0) return 0.0;
    return completedTopics / totalTopics;
  }

  // DATE HELPERS

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _dateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  DateTime? _parseDate(String? value) {
    if (value == null) return null;

    try {
      return _dateOnly(DateTime.parse(value));
    } catch (_) {
      return null;
    }
  }

  bool _isSameDay(DateTime? first, DateTime second) {
    if (first == null) return false;

    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  // LOAD STREAK DATA
  Future<void> _loadStreakData(
    SharedPreferences prefs,
  ) async {
    _lastActivityDate = _parseDate(
      prefs.getString(_lastActivityKey),
    );

    _currentStreak = prefs.getInt(_currentStreakKey) ?? 0;

    _longestStreak = prefs.getInt(_longestStreakKey) ?? 0;

    final today = _dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));

    // Expire the current streak after a full inactive day.
    if (!_isSameDay(_lastActivityDate, today) &&
        !_isSameDay(_lastActivityDate, yesterday)) {
      _currentStreak = 0;
      await prefs.setInt(_currentStreakKey, 0);
    }
  }

  // RECORD DAILY LEARNING ACTIVITY
  Future<void> _recordLearningActivity() async {
    final today = _dateOnly(DateTime.now());

    // Multiple activities on the same day count as one streak day.
    if (_isSameDay(_lastActivityDate, today)) {
      return;
    }

    final yesterday = today.subtract(const Duration(days: 1));

    if (_isSameDay(_lastActivityDate, yesterday)) {
      _currentStreak++;
    } else {
      _currentStreak = 1;
    }

    if (_currentStreak > _longestStreak) {
      _longestStreak = _currentStreak;
    }

    _lastActivityDate = today;

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        _lastActivityKey,
        _dateKey(today),
      );

      await prefs.setInt(
        _currentStreakKey,
        _currentStreak,
      );

      await prefs.setInt(
        _longestStreakKey,
        _longestStreak,
      );
    } catch (_) {
      // Keep the current in-memory streak even if storage fails.
    }
  }

  // LOAD SAVED DATA
  Future<void> loadSkills() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load streak information
      await _loadStreakData(prefs);

      // Load skills
      final savedData = prefs.getString('skills_data');

      if (savedData != null) {
        final List<dynamic> decodedData = jsonDecode(savedData);

        _skills = decodedData
            .map((item) => Skill.fromJson(item))
            .toList();
      } else {
        final oldSkills =
            prefs.getStringList('custom_skills') ?? [];

        _skills = oldSkills
            .map(
              (title) => Skill(
                title: title,
                subtitle: 'My Learning Roadmap',
              ),
            )
            .toList();

        await _saveSkills();
      }

      // Load custom challenges
      final savedChallenges =
          prefs.getString('custom_challenges');

      if (savedChallenges != null) {
        final List<dynamic> decoded =
            jsonDecode(savedChallenges);

        _customChallenges = decoded
            .map((item) => Challenge.fromJson(item))
            .toList();
      }

      // Restore completed challenges and migrate old title values.
      final savedCompleted =
          prefs.getStringList('completed_challenges') ?? [];

      _completedChallengeIds = savedCompleted.map((saved) {
        for (final challenge in [
          ...builtInChallenges,
          ..._customChallenges,
        ]) {
          if (challenge.id == saved ||
              challenge.title == saved) {
            return challenge.id;
          }
        }

        return saved;
      }).toSet();
    } catch (e) {
      errorMessage =
          'Unable to load your skills. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // SAVE SKILLS
  Future<void> _saveSkills() async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      _skills.map((skill) => skill.toJson()).toList(),
    );

    await prefs.setString('skills_data', encoded);
  }

  // SAVE CUSTOM CHALLENGES
  Future<void> _saveCustomChallenges() async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      _customChallenges
          .map((challenge) => challenge.toJson())
          .toList(),
    );

    await prefs.setString('custom_challenges', encoded);
  }

  // SAVE COMPLETED CHALLENGES
  Future<void> _saveCompletedChallenges() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      'completed_challenges',
      _completedChallengeIds.toList(),
    );
  }

  // ADD SKILL
  Future<bool> addSkill(String title) async {
    final cleanTitle = title.trim();

    if (cleanTitle.isEmpty || cleanTitle.length > 30) {
      return false;
    }

    final alreadyExists = _skills.any(
      (skill) =>
          skill.title.toLowerCase() ==
          cleanTitle.toLowerCase(),
    );

    if (alreadyExists) return false;

    _skills.add(
      Skill(
        title: cleanTitle,
        subtitle: 'My Learning Roadmap',
      ),
    );

    await _saveSkills();
    notifyListeners();

    return true;
  }

  // ADD TOPIC
  Future<bool> addTopic(
    String skillTitle,
    String topic,
  ) async {
    final cleanTopic = topic.trim();

    if (cleanTopic.isEmpty || cleanTopic.length > 100) {
      return false;
    }

    final index = _skills.indexWhere(
      (skill) => skill.title == skillTitle,
    );

    if (index == -1) return false;

    final skill = _skills[index];

    if (skill.topics.any(
      (item) =>
          item.toLowerCase() == cleanTopic.toLowerCase(),
    )) {
      return false;
    }

    _skills[index] = skill.copyWith(
      topics: [...skill.topics, cleanTopic],
    );

    await _saveSkills();
    notifyListeners();

    return true;
  }

  // TOGGLE TOPIC COMPLETION
  Future<bool> toggleTopicCompletion(
    String skillTitle,
    String topic,
  ) async {
    final index = _skills.indexWhere(
      (skill) => skill.title == skillTitle,
    );

    if (index == -1) return false;

    final skill = _skills[index];

    if (!skill.topics.contains(topic)) return false;

    final updatedTopics = [...skill.completedTopics];

    final wasCompleted = updatedTopics.contains(topic);

    if (wasCompleted) {
      updatedTopics.remove(topic);
    } else {
      updatedTopics.add(topic);
    }

    _skills[index] = skill.copyWith(
      completedTopics: updatedTopics,
    );

    try {
      await _saveSkills();

      // Record activity only when completing a topic.
      if (!wasCompleted) {
        await _recordLearningActivity();
      }

      notifyListeners();
      return true;
    } catch (_) {
      _skills[index] = skill;
      notifyListeners();
      return false;
    }
  }

  // ADD CUSTOM CHALLENGE
  Future<bool> addCustomChallenge({
    required String title,
    required String category,
    required String difficulty,
    required String description,
  }) async {
    final cleanTitle = title.trim();
    final cleanDescription = description.trim();

    const allowedCategories = [
      'Coding',
      'DSA',
      'Python',
      'Java',
      'Flutter',
      'Concepts',
    ];

    const allowedDifficulties = [
      'Easy',
      'Medium',
      'Hard',
    ];

    if (cleanTitle.length < 3 ||
        cleanTitle.length > 60 ||
        cleanDescription.length < 10 ||
        cleanDescription.length > 500 ||
        !allowedCategories.contains(category) ||
        !allowedDifficulties.contains(difficulty)) {
      return false;
    }

    final alreadyExists = challenges.any(
      (challenge) =>
          challenge.title.toLowerCase() ==
          cleanTitle.toLowerCase(),
    );

    if (alreadyExists) return false;

    final newChallenge = Challenge(
      id: 'custom_${DateTime.now().microsecondsSinceEpoch}',
      title: cleanTitle,
      category: category,
      difficulty: difficulty,
      description: cleanDescription,
    );

    _customChallenges.add(newChallenge);

    try {
      await _saveCustomChallenges();
      notifyListeners();
      return true;
    } catch (_) {
      _customChallenges.removeWhere(
        (item) => item.id == newChallenge.id,
      );
      return false;
    }
  }

  // TOGGLE CHALLENGE COMPLETION
  Future<bool> toggleChallengeCompletion(
    String challengeId,
  ) async {
    if (!challenges.any(
      (challenge) => challenge.id == challengeId,
    )) {
      return false;
    }

    final wasCompleted =
        _completedChallengeIds.contains(challengeId);

    if (wasCompleted) {
      _completedChallengeIds.remove(challengeId);
    } else {
      _completedChallengeIds.add(challengeId);
    }

    try {
      await _saveCompletedChallenges();

      // Record activity only when completing a challenge.
      if (!wasCompleted) {
        await _recordLearningActivity();
      }

      notifyListeners();
      return true;
    } catch (_) {
      if (wasCompleted) {
        _completedChallengeIds.add(challengeId);
      } else {
        _completedChallengeIds.remove(challengeId);
      }

      notifyListeners();
      return false;
    }
  }

  // DELETE SKILL
  Future<bool> deleteSkill(String title) async {
    final oldLength = _skills.length;

    _skills.removeWhere(
      (skill) => skill.title == title,
    );

    if (_skills.length == oldLength) return false;

    await _saveSkills();
    notifyListeners();

    return true;
  }
}