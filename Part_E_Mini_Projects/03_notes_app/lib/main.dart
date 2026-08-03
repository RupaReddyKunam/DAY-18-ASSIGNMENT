import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Note {
  final String id;
  String title;
  String content;
  bool isPinned;

  Note({required this.id, required this.title, required this.content, this.isPinned = false});
}

class NotesProvider extends ChangeNotifier {
  final List<Note> _notes = [
    Note(id: '1', title: 'Flutter Key Concepts', content: 'Widgets, BuildContext, State Lifecycle', isPinned: true),
    Note(id: '2', title: 'Shopping Ideas', content: 'Buy Mechanical Keyboard & Headphones', isPinned: false),
  ];

  String _searchQuery = '';

  List<Note> get notes {
    return _notes.where((n) {
      return n.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          n.content.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addNote(String title, String content) {
    _notes.add(Note(id: DateTime.now().toIso8601String(), title: title, content: content));
    notifyListeners();
  }

  void updateNote(String id, String title, String content) {
    final idx = _notes.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notes[idx].title = title;
      _notes[idx].content = content;
      notifyListeners();
    }
  }

  void togglePin(String id) {
    final idx = _notes.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notes[idx].isPinned = !_notes[idx].isPinned;
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NotesProvider(),
      child: const MaterialApp(home: NotesListScreen()),
    ),
  );
}

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Notes App'),
        backgroundColor: Colors.amber.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: '🔍 Search notes by title or text...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => context.read<NotesProvider>().setSearchQuery(val),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: provider.notes.length,
                itemBuilder: (context, index) {
                  final note = provider.notes[index];
                  return Card(
                    color: note.isPinned ? Colors.amber.shade100 : Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                              ),
                              IconButton(
                                icon: Icon(note.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
                                onPressed: () => context.read<NotesProvider>().togglePin(note.id),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Text(note.content, maxLines: 4, overflow: TextOverflow.ellipsis),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NoteEditScreen(note: note))),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                onPressed: () => context.read<NotesProvider>().deleteNote(note.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NoteEditScreen())),
        backgroundColor: Colors.amber.shade800,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class NoteEditScreen extends StatefulWidget {
  final Note? note;

  const NoteEditScreen({super.key, this.note});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.note?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'Create Note'),
        backgroundColor: Colors.amber.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _contentCtrl,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(labelText: 'Content', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_titleCtrl.text.isNotEmpty && _contentCtrl.text.isNotEmpty) {
                  if (isEditing) {
                    context.read<NotesProvider>().updateNote(widget.note!.id, _titleCtrl.text, _contentCtrl.text);
                  } else {
                    context.read<NotesProvider>().addNote(_titleCtrl.text, _contentCtrl.text);
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
