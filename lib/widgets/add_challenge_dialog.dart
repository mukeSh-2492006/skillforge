import 'package:flutter/material.dart';
class AddChallengeDialog extends StatefulWidget {
  const AddChallengeDialog({super.key});

  @override
  State<AddChallengeDialog> createState() =>
      _AddChallengeDialogState();
}

class _AddChallengeDialogState extends State<AddChallengeDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  String _category = 'Coding';
  String _difficulty = 'Easy';

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _category,
        'difficulty': _difficulty,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Your Challenge'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                maxLength: 60,
                decoration: const InputDecoration(
                  labelText: 'Challenge Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 3) {
                    return 'Enter at least 3 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  'Coding',
                  'DSA',
                  'Python',
                  'Java',
                  'Flutter',
                  'Concepts',
                ].map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _category = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: _difficulty,
                decoration: const InputDecoration(
                  labelText: 'Difficulty',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  'Easy',
                  'Medium',
                  'Hard',
                ].map((difficulty) {
                  return DropdownMenuItem<String>(
                    value: difficulty,
                    child: Text(difficulty),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _difficulty = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _descriptionController,
                maxLength: 500,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 10) {
                    return 'Enter at least 10 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Add Challenge'),
        ),
      ],
    );
  }
}
