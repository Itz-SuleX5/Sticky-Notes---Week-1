import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFD2B48C),
        ),
        child: Stack(
          children: [
            Consumer<NotesProvider>(
              builder: (context, notesProvider, child) {
                return Stack(
                  children: notesProvider.notes
                      .map((note) => NoteCard(
                            note: note,
                            isEditing: isEditing,
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
            heroTag: 'edit',
            child: Icon(isEditing ? Icons.check : Icons.edit),
            backgroundColor: isEditing ? Colors.orange : Colors.blue,
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => _showAddNoteDialog(context),
            heroTag: 'add',
            child: const Icon(Icons.add),
            backgroundColor: Colors.teal,
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    String title = '';
    String description = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Nota'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Título'),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
                onChanged: (value) => description = value,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (title.isNotEmpty && description.isNotEmpty) {
                Provider.of<NotesProvider>(context, listen: false)
                    .addNote(title, description);
                Navigator.pop(context);
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }
} 