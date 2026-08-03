import 'package:flutter/material.dart';

/// Challenge 3: Implement lifting state up between two sibling widgets.

void main() {
  runApp(const MaterialApp(home: ParentContainerWidget()));
}

// Common Nearest Parent owning the shared state
class ParentContainerWidget extends StatefulWidget {
  const ParentContainerWidget({super.key});

  @override
  State<ParentContainerWidget> createState() => _ParentContainerWidgetState();
}

class _ParentContainerWidgetState extends State<ParentContainerWidget> {
  // Shared state lifted up to common parent
  String _sharedText = 'Initial Sibling Value';

  void _updateSharedText(String newText) {
    setState(() {
      _sharedText = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Challenge 3: Lifting State Up')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Parent Widget owns State',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Sibling A: Input Controller
            SiblingInputWidget(onTextChanged: _updateSharedText),
            const SizedBox(height: 20),
            // Sibling B: Display Receiver
            SiblingDisplayWidget(textToDisplay: _sharedText),
          ],
        ),
      ),
    );
  }
}

// Sibling A - Triggers callback function
class SiblingInputWidget extends StatelessWidget {
  final ValueChanged<String> onTextChanged;

  const SiblingInputWidget({super.key, required this.onTextChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Sibling A (Sender Input)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Type message to send to Sibling B...',
                border: OutlineInputBorder(),
              ),
              onChanged: onTextChanged,
            ),
          ],
        ),
      ),
    );
  }
}

// Sibling B - Receives state prop from parent
class SiblingDisplayWidget extends StatelessWidget {
  final String textToDisplay;

  const SiblingDisplayWidget({super.key, required this.textToDisplay});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Sibling B (Receiver Display)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              textToDisplay,
              style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
