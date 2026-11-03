import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool remindersEnabled = false;
  bool isLoading = true;

  static const String reminderKey =
      'skill_sprint_reminders_enabled';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!mounted) return;

      setState(() {
        remindersEnabled = prefs.getBool(reminderKey) ?? false;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateReminders(bool value) async {
    setState(() {
      remindersEnabled = value;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(reminderKey, value);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings preference saved successfully!'),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        remindersEnabled = !value;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to save settings.'),
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
          'Settings',
          style: TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Preferences',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  color: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(
                      color: AppColors.slateVeryLight,
                    ),
                  ),
                  child: SwitchListTile(
                    value: remindersEnabled,
                    activeThumbColor: AppColors.primary,
                    secondary: const CircleAvatar(
                      backgroundColor: AppColors.blue50,
                      child: Icon(
                        Icons.notifications_active_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    title: const Text(
                      'Learning Reminders',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: const Text(
                      'Save your reminder preference.',
                      style: TextStyle(fontSize: 12),
                    ),
                    onChanged: _updateReminders,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Text(
                    'This stores your preference on this device. '
                    'Automatic notification scheduling is not configured yet.',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'About',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  color: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(
                      color: AppColors.slateVeryLight,
                    ),
                  ),
                  child: const ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.blue50,
                      child: Icon(
                        Icons.school_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(
                      'SkillSprint',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      'Learn Skills. Track Progress. Grow Together.',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// 9. HELP AND SUPPORT SCREEN
