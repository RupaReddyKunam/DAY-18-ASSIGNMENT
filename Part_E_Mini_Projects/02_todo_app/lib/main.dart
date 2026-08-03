import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Task {
  final String id;
  String title;
  bool isCompleted;

  Task({required this.id, required this.title, this.isCompleted = false});
}

class TodoProvider extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(id: '1', title: 'Complete Day 18 Flutter State Management'),
    Task(id: '2', title: 'Review Provider and ChangeNotifier patterns', isCompleted: true),
  ];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(String title) {
    _tasks.add(Task(id: DateTime.now().toIso8601String(), title: title));
    notifyListeners();
  }

  void toggleTask(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _tasks[idx].isCompleted = !_tasks[idx].isCompleted;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider(),
      child: const MaterialApp(home: TodoApp()),
    ),
  );
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('✅ Provider To-Do App'),
        backgroundColor: Colors.teal,
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
                      hintText: 'What needs to be done?',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      context.read<TodoProvider>().addTask(_controller.text);
                      _controller.clear();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: todoProvider.tasks.length,
                itemBuilder: (context, index) {
                  final task = todoProvider.tasks[index];
                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => context.read<TodoProvider>().toggleTask(task.id),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => context.read<TodoProvider>().deleteTask(task.id),
                      ),
                    ),
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
