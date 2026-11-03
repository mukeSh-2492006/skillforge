import 'package:flutter/material.dart';

class AddTopicDialog extends StatefulWidget {
  const AddTopicDialog({super.key});

  @override
  State<AddTopicDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<AddTopicDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTopic() {
    final topic = _controller.text.trim();

    if (topic.isEmpty) {
      setState(() {
        _errorText = 'Please enter a topic name.';
      });
      return;
    }

    Navigator.of(context).pop(topic);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Topic'),
      content: TextField(
        controller: _controller,
        maxLength: 100,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Topic Name',
          hintText: 'Example: Introduction',
          border: const OutlineInputBorder(),
          errorText: _errorText,
        ),
        onChanged: (_) {
          if (_errorText != null) {
            setState(() {
              _errorText = null;
            });
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addTopic,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
