import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Exercise 5: Build a dynamic list (add/remove items) with Provider.

class ItemListModel extends ChangeNotifier {
  final List<String> _items = ['Flutter', 'Dart', 'Provider'];

  List<String> get items => List.unmodifiable(_items);

  void addItem(String item) {
    if (item.trim().isNotEmpty) {
      _items.add(item.trim());
      notifyListeners();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ItemListModel(),
      child: const MaterialApp(home: DynamicListApp()),
    ),
  );
}

class DynamicListApp extends StatefulWidget {
  const DynamicListApp({super.key});

  @override
  State<DynamicListApp> createState() => _DynamicListAppState();
}

class _DynamicListAppState extends State<DynamicListApp> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('5. Dynamic List with Provider'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter new item name...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ItemListModel>().addItem(_controller.text);
                    _controller.clear();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<ItemListModel>(
                builder: (context, listModel, child) {
                  if (listModel.items.isEmpty) {
                    return const Center(child: Text('No items in list. Add some above!'));
                  }
                  return ListView.builder(
                    itemCount: listModel.items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(listModel.items[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              listModel.removeItem(index);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
