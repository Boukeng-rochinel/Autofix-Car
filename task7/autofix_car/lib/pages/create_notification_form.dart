// lib/screens/create_notification_form.dart
import 'package:flutter/material.dart';
import 'package:autofix_car/services/notification_service.dart';
import 'package:autofix_car/models/notification_item.dart';

class CreateNotificationForm extends StatefulWidget {
  const CreateNotificationForm({super.key});

  @override
  State<CreateNotificationForm> createState() => _CreateNotificationFormState();
}

class _CreateNotificationFormState extends State<CreateNotificationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedType = 'alert'; // Default type
  final List<String> _notificationTypes = [
    'alert',
    'promotion',
    'update',
    'critical',
    'info',
  ];

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _userIdController.dispose();
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitNotification() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final newNotification = NotificationItem(
        userId: _userIdController.text.trim().isEmpty
            ? ''
            : _userIdController.text.trim(),
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        type: _selectedType,
        timestamp: DateTime.now(), // Provide current timestamp
        // isRead and data are typically set/managed by the backend
        // You can add fields for 'data' if you need to send dynamic JSON data from the UI
        data: const {}, // Empty for now, can be expanded
      );

      await NotificationService.createNotification(newNotification);

      setState(() {
        _successMessage = 'Notification created successfully!';
        _userIdController.clear();
        _titleController.clear();
        _messageController.clear();
        _selectedType = 'alert'; // Reset to default
      });
      // Optionally, show a SnackBar or navigate
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_successMessage!)));
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create notification: ${e.toString()}';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage!)));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Notification'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Send a notification to a specific user (by ID) or leave blank to send to all users.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _userIdController,
                decoration: InputDecoration(
                  labelText: 'User ID (Optional - leave blank for all users)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Notification Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.text_fields),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title for the notification.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notification Message',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.message),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a message for the notification.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Notification Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.category),
                ),
                items: _notificationTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _submitNotification,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send, color: Colors.white),
                label: Text(
                  _isLoading ? 'Sending...' : 'Send Notification',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (_successMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _successMessage!,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
