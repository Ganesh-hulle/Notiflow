import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notification_bloc.dart';
import '../models/notification_model.dart';

class ComposeNotificationScreen extends StatefulWidget {
  const ComposeNotificationScreen({super.key});

  @override
  State<ComposeNotificationScreen> createState() =>
      _ComposeNotificationScreenState();
}

class _ComposeNotificationScreenState extends State<ComposeNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _senderNameController = TextEditingController(text: 'Me');
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  final List<int> _senderColors = const [
    0xFF4CAF50,
    0xFFF44336,
    0xFF2196F3,
    0xFFFF9800,
    0xFF9C27B0,
  ];

  int _selectedColor = 0xFF4CAF50;

  @override
  void dispose() {
    _senderNameController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _sendNotification() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderName: _senderNameController.text.trim(),
      senderColor: _selectedColor,
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      timestamp: DateTime.now(),
    );

    context.read<NotificationBloc>().add(SendNotification(notification));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Notification')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _senderNameController,
                decoration: const InputDecoration(
                  labelText: 'Sender name',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a sender name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                minLines: 4,
                maxLines: 7,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Sender color',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _senderColors.map((color) {
                  final isSelected = color == _selectedColor;
                  return InkResponse(
                    onTap: () => setState(() => _selectedColor = color),
                    radius: 28,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(color),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: _sendNotification,
                icon: const Icon(Icons.send),
                label: const Text('Send notification'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
