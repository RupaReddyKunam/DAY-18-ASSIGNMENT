import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Challenge D4: Build a list with full CRUD (Add/Edit/Delete) via Provider.

class TaskItem {
  final String id;
  String title;

  TaskItem({required this.id, required this.title});
}

class TaskCrudModel extends ChangeNotifier {
  final List<TaskItem> _tasks = [
    TaskItem(id: '1', title: 'Learn Flutter State Management'),
    TaskItem(id: '2', title: 'Master Provider & ChangeNotifier'),
  ];

  List<TaskItem> get tasks => List.unmodifiable(_tasks);

  void addTask(String title) {
    _tasks.add(TaskItem(id: DateTime.now().toIso8601String(), title: title));
    notifyListeners();
  }

  void updateTask(String id, String newTitle) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _tasks[idx].title = newTitle;
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
      create: (_) => TaskCrudModel(),
      child: const MaterialApp(home: TaskCrudScreen()),
    ),
  );
}

class TaskCrudScreen extends StatefulWidget {
  const TaskCrudScreen({super.key});

  @override
  State<TaskCrudScreen> createState() => _TaskCrudScreenState();
}

class _TaskCrudScreenState extends State<TaskCrudScreen> {
  final _controller = TextEditingController();

  void _showEditDialog(BuildContext context, TaskItem task) {
    final editCtrl = TextEditingController(text: task.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(controller: editCtrl),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              context.read<TaskCrudModel>().updateTask(task.id, editCtrl.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskModel = context.watch<TaskCrudModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('D4: Full CRUD List via Provider')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'New task title...', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      context.read<TaskCrudModel>().addTask(_controller.text);
                      _controller.clear();
                    }
                  },
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: taskModel.tasks.length,
              itemBuilder: (context, index) {
                final task = taskModel.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.amber), onPressed: () => _showEditDialog(context, task)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => context.read<TaskCrudModel>().deleteTask(task.id)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
