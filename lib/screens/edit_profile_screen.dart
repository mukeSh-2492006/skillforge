import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialBranch;
  final String initialYear;
  final String initialCollege;
  final String initialGoal;

  const EditProfileScreen({
    super.key,
    required this.initialName,
    required this.initialBranch,
    required this.initialYear,
    required this.initialCollege,
    required this.initialGoal,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _collegeController;
  late final TextEditingController _goalController;

  final List<String> branches = [
    'CSE',
    'CSE (AI&ML)',
    'CSE (Data Science)',
    'IT',
    'ECE',
    'EEE',
    'Mechanical',
    'Civil',
    'Other',
  ];

  final List<String> years = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];

  late String selectedBranch;
  late String selectedYear;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.initialName == 'Student'
          ? ''
          : widget.initialName,
    );

    _collegeController = TextEditingController(
      text: widget.initialCollege,
    );

    _goalController = TextEditingController(
      text: widget.initialGoal,
    );

    selectedBranch = branches.contains(widget.initialBranch)
        ? widget.initialBranch
        : 'Other';

    selectedYear = years.contains(widget.initialYear)
        ? widget.initialYear
        : '3rd Year';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _collegeController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  // SAVE PROFILE
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSaving = true;
    });

    final name = _nameController.text.trim();
    final college = _collegeController.text.trim();
    final goal = _goalController.text.trim();

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('profile_name', name);
      await prefs.setString('profile_branch', selectedBranch);
      await prefs.setString('profile_year', selectedYear);
      await prefs.setString('profile_college', college);
      await prefs.setString('profile_goal', goal);

      if (!mounted) return;

      Navigator.pop(
        context,
        {
          'name': name,
          'branch': selectedBranch,
          'year': selectedYear,
          'college': college,
          'goal': goal,
        },
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to save profile. Please try again.'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.navy,
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Center(
              child: CircleAvatar(
                radius: 38,
                backgroundColor: AppColors.blue100,
                child: Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 42,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // NAME
            const Text(
              'Full Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _nameController,
              maxLength: 40,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }

                if (value.trim().length < 2) {
                  return 'Name must contain at least 2 characters';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            // BRANCH
            const Text(
              'Branch',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: selectedBranch,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.school_outlined),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: branches.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: isSaving
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          selectedBranch = value;
                        });
                      }
                    },
            ),

            const SizedBox(height: 20),

            // YEAR
            const Text(
              'Year of Study',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: selectedYear,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.calendar_today_outlined,
                ),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: years.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: isSaving
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          selectedYear = value;
                        });
                      }
                    },
            ),

            const SizedBox(height: 20),

            // COLLEGE
            const Text(
              'College Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _collegeController,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: 'Enter your college name',
                prefixIcon: const Icon(
                  Icons.account_balance_outlined,
                ),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // LEARNING GOAL
            const Text(
              'Learning Goal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _goalController,
              maxLength: 100,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'What is your learning goal?',
                prefixIcon: const Icon(Icons.track_changes),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your learning goal';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            // SAVE BUTTON
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Save Profile',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 8. SETTINGS SCREEN
