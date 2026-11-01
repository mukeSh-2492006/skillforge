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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitSkill() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final skillName = _controller.text.trim();

    await context.read<SkillProvider>().addSkill(skillName);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Skill Added Successfully!'),
      ),
    );

    Navigator.pop(context);
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
              ElevatedButton(
                onPressed: _submitSkill,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}