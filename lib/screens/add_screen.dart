import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/skill_provider.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitSkill() async {
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final skillName = _controller.text.trim();
    final provider = context.read<SkillProvider>();
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Check whether the skill already exists.
      final alreadyExists = provider.skills.any(
        (skill) =>
            skill.title.trim().toLowerCase() ==
            skillName.toLowerCase(),
      );

      if (alreadyExists) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('This skill already exists!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Add the skill and check the result.
      final success = await provider.addSkill(skillName);

      if (!mounted) return;

      if (!success) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Unable to add skill. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      Navigator.pop(context);

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Skill added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Skill'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                maxLength: 30,
                decoration: const InputDecoration(
                  labelText: 'Skill Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a skill name';
                  }

                  if (value.trim().length < 2) {
                    return 'Enter at least 2 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitSkill,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}