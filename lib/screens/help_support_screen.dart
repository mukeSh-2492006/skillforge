import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Widget _buildFaq(String question, String answer) {
    return Card(
      color: AppColors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(
          color: AppColors.slateVeryLight,
        ),
      ),
      child: ExpansionTile(
        iconColor: AppColors.primary,
        collapsedIconColor: AppColors.grey,
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: AppColors.navy,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.slateMedium,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
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
          'Help & Support',
          style: TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.blue50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.support_agent,
                  size: 36,
                  color: AppColors.primary,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How can we help?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Find answers to common questions about SkillSprint.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.slateMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),

          const SizedBox(height: 12),

          _buildFaq(
            'How do I add a new skill?',
            'Open Roadmaps and use the Add Skill option.',
          ),

          _buildFaq(
            'How can I track my learning progress?',
            'Open Progress or Profile to see completed topics and overall progress.',
          ),

          _buildFaq(
            'How do I complete a challenge?',
            'Open Challenges, select a challenge and tap Mark Completed.',
          ),

          _buildFaq(
            'How can I earn achievements?',
            'Complete roadmap topics and challenges to unlock achievements.',
          ),

          _buildFaq(
            'Will my learning data remain saved?',
            'SkillSprint saves your learning data locally on your device using SharedPreferences.',
          ),

          const SizedBox(height: 18),

          const Text(
            'Need More Help?',
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
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.greenBackground,
                child: Icon(
                  Icons.contact_support_outlined,
                  color: AppColors.green,
                ),
              ),
              title: const Text(
                'Contact Support',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              subtitle: const Text(
                'Get help with an app issue.',
                style: TextStyle(fontSize: 11),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.grey,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: const Text('Contact Support'),
                      content: const Text(
                        'For help with SkillSprint, contact your '
                        'project mentor or app development team. '
                        'Share a screenshot and describe the issue.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: const Text('Got it'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
