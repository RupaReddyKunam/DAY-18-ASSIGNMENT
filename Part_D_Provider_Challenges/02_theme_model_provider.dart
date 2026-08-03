import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Challenge D2: Build a ThemeModel toggling the app theme via Provider.

class ThemeModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: const ThemeApp(),
    ),
  );
}

class ThemeApp extends StatelessWidget {
  const ThemeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeModel>();

    return MaterialApp(
      themeMode: themeModel.themeMode,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const ThemeToggleScreen(),
    );
  }
}

class ThemeToggleScreen extends StatelessWidget {
  const ThemeToggleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentMode = context.watch<ThemeModel>().themeMode;

    return Scaffold(
      appBar: AppBar(title: const Text('D2: App Theme Switcher')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('System Default'),
              value: ThemeMode.system,
              groupValue: currentMode,
              onChanged: (mode) => context.read<ThemeModel>().setThemeMode(mode!),
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Light Mode ☀️'),
              value: ThemeMode.light,
              groupValue: currentMode,
              onChanged: (mode) => context.read<ThemeModel>().setThemeMode(mode!),
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark Mode 🌙'),
              value: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: (mode) => context.read<ThemeModel>().setThemeMode(mode!),
            ),
          ],
        ),
      ),
    );
  }
}
