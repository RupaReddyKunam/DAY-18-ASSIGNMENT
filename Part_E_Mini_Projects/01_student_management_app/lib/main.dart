import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- Student Data Model ---
class Student {
  final String id;
  String name;
  String email;
  String rollNumber;
  String course;
  String grade;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.rollNumber,
    required this.course,
    required this.grade,
  });
}

// --- Student Provider State ---
class StudentProvider extends ChangeNotifier {
  final List<Student> _students = [
    Student(id: '1', name: 'Alice Smith', email: 'alice@univ.edu', rollNumber: 'CS101', course: 'Computer Science', grade: 'A'),
    Student(id: '2', name: 'Bob Jones', email: 'bob@univ.edu', rollNumber: 'EC102', course: 'Electronics', grade: 'B+'),
    Student(id: '3', name: 'Charlie Brown', email: 'charlie@univ.edu', rollNumber: 'ME103', course: 'Mechanical', grade: 'A-'),
  ];

  String _searchQuery = '';
  String _selectedCourse = 'ALL';

  List<Student> get students {
    return _students.where((s) {
      final matchesSearch = s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.rollNumber.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCourse = _selectedCourse == 'ALL' || s.course == _selectedCourse;
      return matchesSearch && matchesCourse;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCourseFilter(String course) {
    _selectedCourse = course;
    notifyListeners();
  }

  void addStudent(Student student) {
    _students.add(student);
    notifyListeners();
  }

  void updateStudent(String id, Student updated) {
    final index = _students.indexWhere((s) => s.id == id);
    if (index != -1) {
      _students[index] = updated;
      notifyListeners();
    }
  }

  void deleteStudent(String id) {
    _students.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => StudentProvider(),
      child: const MaterialApp(
        title: 'Student Management App',
        debugShowCheckedModeBanner: false,
        home: StudentDashboardScreen(),
      ),
    ),
  );
}

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  void _showStudentDialog(BuildContext context, [Student? student]) {
    final nameCtrl = TextEditingController(text: student?.name ?? '');
    final emailCtrl = TextEditingController(text: student?.email ?? '');
    final rollCtrl = TextEditingController(text: student?.rollNumber ?? '');
    final courseCtrl = TextEditingController(text: student?.course ?? 'Computer Science');
    final gradeCtrl = TextEditingController(text: student?.grade ?? 'A');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(student == null ? '➕ Add Student' : '✏️ Edit Student'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: rollCtrl, decoration: const InputDecoration(labelText: 'Roll Number')),
              TextField(controller: courseCtrl, decoration: const InputDecoration(labelText: 'Course')),
              TextField(controller: gradeCtrl, decoration: const InputDecoration(labelText: 'Grade')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && rollCtrl.text.isNotEmpty) {
                final newStudent = Student(
                  id: student?.id ?? DateTime.now().toIso8601String(),
                  name: nameCtrl.text,
                  email: emailCtrl.text,
                  rollNumber: rollCtrl.text,
                  course: courseCtrl.text,
                  grade: gradeCtrl.text,
                );

                if (student == null) {
                  ctx.read<StudentProvider>().addStudent(newStudent);
                } else {
                  ctx.read<StudentProvider>().updateStudent(student.id, newStudent);
                }
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save Record'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎓 Student Management Dashboard'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: '🔍 Search by name or roll number...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => context.read<StudentProvider>().setSearchQuery(val),
            ),
            const SizedBox(height: 12),
            Row(
              children: ['ALL', 'Computer Science', 'Electronics', 'Mechanical'].map((course) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ChoiceChip(
                    label: Text(course),
                    selected: provider._selectedCourse == course,
                    onSelected: (_) => context.read<StudentProvider>().setCourseFilter(course),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: provider.students.length,
                itemBuilder: (context, index) {
                  final s = provider.students[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(child: Text(s.name[0])),
                      title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${s.rollNumber} • ${s.course} • Grade: ${s.grade}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit, color: Colors.amber), onPressed: () => _showStudentDialog(context, s)),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => context.read<StudentProvider>().deleteStudent(s.id)),
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
        onPressed: () => _showStudentDialog(context),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
