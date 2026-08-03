import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Challenge 1: Build a dark mode toggle first with setState, then with Provider.

// --- Approach 2: Provider Managed Dark Mode ---
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const DarkModeToggleApp(),
    ),
  );
}

class DarkModeToggleApp extends StatelessWidget {
  const DarkModeToggleApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listens to ThemeProvider for app-wide theme switching
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return MaterialApp(
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: const ToggleDemoScreen(),
    );
  }
}

class ToggleDemoScreen extends StatefulWidget {
  const ToggleDemoScreen({super.key});

  @override
  State<ToggleDemoScreen> createState() => _ToggleDemoScreenState();
}

class _ToggleDemoScreenState extends State<ToggleDemoScreen> {
  // --- Approach 1: Local setState Dark Mode ---
  bool _localDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final providerDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Challenge 1: Dark Mode Toggle')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Section 1: setState Toggle
            Card(
              child: ListTile(
                title: const Text('Local setState Dark Mode'),
                subtitle: Text('Local State: ${_localDarkMode ? "DARK" : "LIGHT"}'),
                trailing: Switch(
                  value: _localDarkMode,
                  onChanged: (val) {
                    setState(() {
                      _localDarkMode = val;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Section 2: Provider Global Toggle
            Card(
              color: providerDark ? Colors.grey[850] : Colors.blue.shade50,
              child: ListTile(
                title: const Text('App-Wide Provider Dark Mode'),
                subtitle: Text('Global App Theme: ${providerDark ? "DARK" : "LIGHT"}'),
                trailing: Switch(
                  value: providerDark,
                  onChanged: (_) {
                    context.read<ThemeProvider>().toggleTheme();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
