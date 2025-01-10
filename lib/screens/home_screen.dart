import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cork_board.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Consumer<NotesProvider>(
              builder: (context, notesProvider, child) {
                return Stack(
                  children: notesProvider.notes
                      .map((note) => NoteCard(note: note))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteDialog(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    String title = '';
    String description = '';
    DateTime deadline = DateTime.now();
    Color selectedColor =
        Provider.of<NotesProvider>(context, listen: false).noteColors.first;

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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: deadline,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    deadline = picked;
                  }
                },
                child: const Text('Seleccionar Fecha Límite'),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: Provider.of<NotesProvider>(context)
                    .noteColors
                    .map((color) => GestureDetector(
                          onTap: () => selectedColor = color,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: color == selectedColor
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                            ),
                          ),
                        ))
                    .toList(),
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
                    .addNote(title, description, deadline, selectedColor);
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