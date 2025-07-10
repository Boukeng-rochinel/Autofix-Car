import 'package:flutter/material.dart';
import '../models/faq_item.dart';
import '../services/faq_service.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class CreateFaqForm extends StatefulWidget {
  const CreateFaqForm({Key? key}) : super(key: key);

  @override
  State<CreateFaqForm> createState() => _CreateFaqFormState();
}

class _CreateFaqFormState extends State<CreateFaqForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final faq = FAQItem(
        question: _questionController.text.trim(),
        answer: _answerController.text.trim(),
      );
      await FAQService.createFAQ(faq);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('FAQ created successfully!')),
        );
        _formKey.currentState!.reset();
        _questionController.clear();
        _answerController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create FAQ: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.blueGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Create FAQ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                TextFormField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    labelText: 'Question',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Enter a question' : null,
                  maxLines: 2,
                  style: AppStyles.bodyText,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _answerController,
                  decoration: InputDecoration(
                    labelText: 'Answer',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Enter an answer' : null,
                  maxLines: 4,
                  style: AppStyles.bodyText,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Create FAQ'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
