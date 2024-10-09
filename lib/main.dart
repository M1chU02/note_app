import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'models/note.dart';
import 'note_form.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteListScreen(),
    );
  }
}

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await DatabaseHelper().getNotes();
    setState(() {
      _notes = notes;
    });
  }

  void _addOrUpdateNote([Note? note]) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteFormScreen(note: note),
      ),
    );
    if (result == true) {
      _loadNotes();
    }
  }

  void _deleteNote(int id) async {
    await DatabaseHelper().deleteNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.content),
            onTap: () => _addOrUpdateNote(note),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteNote(note.id!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrUpdateNote(),
        child: Icon(Icons.add),
      ),
    );
  }
}
