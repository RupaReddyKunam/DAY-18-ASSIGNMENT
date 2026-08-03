import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: TextControllerFormApp()));
}

/// Exercise 2: Form with TextEditingController initialized in initState and properly disposed.
class TextControllerFormApp extends StatefulWidget {
  const TextControllerFormApp({super.key});

  @override
  State<TextControllerFormApp> createState() => _TextControllerFormAppState();
}

class _TextControllerFormAppState extends State<TextControllerFormApp> {
  // Controllers initialized
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  String _submittedText = '';

  @override
  void initState() {
    super.initState();
    // Properly initialize controllers in initState
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    // ⚠️ CRITICAL: Properly dispose controllers to prevent memory leaks
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    setState(() {
      _submittedText = 'Name: ${_nameController.text}\nEmail: ${_emailController.text}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2. TextEditingController & Proper Disposal'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Submit Form', style: TextStyle(fontSize: 16)),
            ),
            if (_submittedText.isNotEmpty) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.teal),
                ),
                child: Text(
                  _submittedText,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
