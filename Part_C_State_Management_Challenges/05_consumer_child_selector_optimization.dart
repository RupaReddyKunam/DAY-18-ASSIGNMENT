import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Challenge 5: Optimize a Consumer using the child parameter and Selector.

class HeavyDataModel extends ChangeNotifier {
  int _counter = 0;
  String _title = 'Optimized Performance Screen';

  int get counter => _counter;
  String get title => _title;

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }

  void updateTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => HeavyDataModel(),
      child: const MaterialApp(home: OptimizationDemoScreen()),
    ),
  );
}

class OptimizationDemoScreen extends StatelessWidget {
  const OptimizationDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Challenge 5: Consumer & Selector Optimization')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. Selector Example: Rebuilds ONLY when counter property changes!
            Selector<HeavyDataModel, int>(
              selector: (context, model) => model.counter,
              builder: (context, counterValue, child) {
                return Text(
                  'Counter (Selector Optimized): $counterValue',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
                );
              },
            ),
            const SizedBox(height: 20),

            // 2. Consumer with `child` parameter optimization (child widget is built once and re-used)
            Consumer<HeavyDataModel>(
              builder: (context, model, cachedChild) {
                return Column(
                  children: [
                    Text('Title: ${model.title}'),
                    const SizedBox(height: 10),
                    // cachedChild passed here is NOT rebuilt during notifyListeners!
                    cachedChild!,
                  ],
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.amber.shade100,
                child: const Text(
                  '⚡ Heavy Expensive Subtree (Never Rebuilt because it uses child parameter)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => context.read<HeavyDataModel>().incrementCounter(),
                  child: const Text('Increment Counter'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => context.read<HeavyDataModel>().updateTitle('Title Updated at ${DateTime.now().second}s'),
                  child: const Text('Change Title'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
