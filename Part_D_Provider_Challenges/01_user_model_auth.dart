import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Challenge D1: Build a UserModel managing login/logout state app-wide.

class User {
  final String email;
  final String name;
  final String token;

  User({required this.email, required this.name, required this.token});
}

class UserModel extends ChangeNotifier {
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  void login(String email, String name) {
    _user = User(email: email, name: name, token: 'jwt_mock_token_12345');
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserModel(),
      child: const AuthApp(),
    ),
  );
}

class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<UserModel>();

    return MaterialApp(
      home: auth.isLoggedIn ? const UserHomeScreen() : const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('D1: UserModel Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 12),
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_nameCtrl.text.isNotEmpty && _emailCtrl.text.isNotEmpty) {
                  context.read<UserModel>().login(_emailCtrl.text, _nameCtrl.text);
                }
              },
              child: const Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModel>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile Dashboard'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 40, child: Text(user?.name[0] ?? 'U', style: const TextStyle(fontSize: 32))),
            const SizedBox(height: 16),
            Text('Welcome, ${user?.name}!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('Email: ${user?.email}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<UserModel>().logout(),
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
