import 'package:flutter/material.dart';
import 'models/note.dart';
import 'db_helper.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? note;

  NoteFormScreen({this.note});

  @override
  _NoteFormScreenState createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;

  @override
  void initState() {
    super.initState();
    _title = widget.note?.title ?? '';
    _content = widget.note?.content ?? '';
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newNote = Note(
        id: widget.note?.id,
        title: _title,
        content: _content,
      );

      if (widget.note == null) {
        await DatabaseHelper().addNote(newNote);
      } else {
        await DatabaseHelper().updateNote(newNote);
      }

      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _content,
                decoration: InputDecoration(labelText: 'Content'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
                onSaved: (value) {
                  _content = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveNote,
                child: Text('Save Note'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
