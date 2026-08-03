import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Exercise 4: Share state between two screens using Provider.

class SharedDataModel extends ChangeNotifier {
  String _message = 'Hello from Screen 1!';
  String get message => _message;

  void updateMessage(String newMessage) {
    _message = newMessage;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SharedDataModel(),
      child: const MaterialApp(home: FirstScreen()),
    ),
  );
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('4. Multi-Screen State (Screen 1)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<SharedDataModel>(
                builder: (context, data, child) => Text(
                  data.message,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<SharedDataModel>().updateMessage('Message Updated on Screen 1!');
                },
                child: const Text('Update Message'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SecondScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                child: const Text('Go to Screen 2 ➔'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen 2'), backgroundColor: Colors.orange),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Reading state from Screen 2:', style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 10),
              Consumer<SharedDataModel>(
                builder: (context, data, child) => Text(
                  data.message,
                  style: const TextStyle(fontSize: 22, color: Colors.orange, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<SharedDataModel>().updateMessage('Modified from Screen 2! 🎉');
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                child: const Text('Modify Message from Screen 2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
