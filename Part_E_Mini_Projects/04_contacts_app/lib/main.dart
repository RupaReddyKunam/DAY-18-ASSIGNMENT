import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Contact {
  final String id;
  String name;
  String email;
  String phone;
  String company;

  Contact({required this.id, required this.name, required this.email, required this.phone, required this.company});
}

class ContactsProvider extends ChangeNotifier {
  final List<Contact> _contacts = [
    Contact(id: '1', name: 'John Doe', email: 'john@example.com', phone: '+1 555-0192', company: 'Acme Corp'),
    Contact(id: '2', name: 'Sarah Connor', email: 'sarah@skynet.net', phone: '+1 555-0144', company: 'Cyberdyne'),
  ];

  String _query = '';

  List<Contact> get contacts {
    return _contacts.where((c) {
      return c.name.toLowerCase().contains(_query.toLowerCase()) ||
          c.company.toLowerCase().contains(_query.toLowerCase());
    }).toList();
  }

  void setSearchQuery(String q) {
    _query = q;
    notifyListeners();
  }

  void addContact(Contact c) {
    _contacts.add(c);
    notifyListeners();
  }

  void updateContact(String id, Contact updated) {
    final idx = _contacts.indexWhere((c) => c.id == id);
    if (idx != -1) {
      _contacts[idx] = updated;
      notifyListeners();
    }
  }

  void deleteContact(String id) {
    _contacts.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ContactsProvider(),
      child: const MaterialApp(home: ContactsListScreen()),
    ),
  );
}

class ContactsListScreen extends StatelessWidget {
  const ContactsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContactsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎴 Contacts Directory'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: '🔍 Search by name or company...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => context.read<ContactsProvider>().setSearchQuery(val),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: provider.contacts.length,
                itemBuilder: (context, idx) {
                  final contact = provider.contacts[idx];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        child: Text(contact.name[0], style: const TextStyle(color: Colors.white)),
                      ),
                      title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${contact.company} • ${contact.phone}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ContactDetailScreen(contact: contact)),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactFormScreen()));
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}

class ContactDetailScreen extends StatelessWidget {
  final Contact contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ContactFormScreen(contact: contact)));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              context.read<ContactsProvider>().deleteContact(contact.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(radius: 50, child: Text(contact.name[0], style: const TextStyle(fontSize: 40))),
            const SizedBox(height: 16),
            Text(contact.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(contact.company, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const Divider(height: 40),
            ListTile(leading: const Icon(Icons.phone), title: Text(contact.phone)),
            ListTile(leading: const Icon(Icons.email), title: Text(contact.email)),
          ],
        ),
      ),
    );
  }
}

class ContactFormScreen extends StatefulWidget {
  final Contact? contact;

  const ContactFormScreen({super.key, this.contact});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _companyCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.contact?.name ?? '');
    _emailCtrl = TextEditingController(text: widget.contact?.email ?? '');
    _phoneCtrl = TextEditingController(text: widget.contact?.phone ?? '');
    _companyCtrl = TextEditingController(text: widget.contact?.company ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _companyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Contact' : 'Add Contact')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
            TextField(controller: _companyCtrl, decoration: const InputDecoration(labelText: 'Company')),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final newContact = Contact(
                  id: widget.contact?.id ?? DateTime.now().toIso8601String(),
                  name: _nameCtrl.text,
                  email: _emailCtrl.text,
                  phone: _phoneCtrl.text,
                  company: _companyCtrl.text,
                );

                if (isEditing) {
                  context.read<ContactsProvider>().updateContact(widget.contact!.id, newContact);
                } else {
                  context.read<ContactsProvider>().addContact(newContact);
                }
                Navigator.pop(context);
              },
              child: const Text('Save Contact'),
            ),
          ],
        ),
      ),
    );
  }
}
