import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Challenge D3: Use MultiProvider with two ChangeNotifiers (UserNotifier + CartNotifier).

class UserNotifier extends ChangeNotifier {
  String _username = 'Guest User';
  String get username => _username;

  void setUsername(String name) {
    _username = name;
    notifyListeners();
  }
}

class CartNotifier extends ChangeNotifier {
  int _itemCount = 0;
  int get itemCount => _itemCount;

  void increment() {
    _itemCount++;
    notifyListeners();
  }

  void reset() {
    _itemCount = 0;
    notifyListeners();
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserNotifier()),
        ChangeNotifierProvider(create: (_) => CartNotifier()),
      ],
      child: const MaterialApp(home: MultiProviderScreen()),
    ),
  );
}

class MultiProviderScreen extends StatelessWidget {
  const MultiProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final username = context.watch<UserNotifier>().username;
    final cartCount = context.watch<CartNotifier>().itemCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $username'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: Text('🛒 Items: $cartCount', style: const TextStyle(fontSize: 16))),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => context.read<UserNotifier>().setUsername('Alice (LoggedIn)'),
              child: const Text('Log In as Alice'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<CartNotifier>().increment(),
              child: const Text('Add Product to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
