import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final bool isEditing;

  const NoteCard({
    Key? key,
    required this.note,
    required this.isEditing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final notePosition = note.position?.dy ?? 0;
    final isNearTop = notePosition < screenHeight * 0.3;
    final isNearBottom = notePosition > screenHeight * 0.7;

    return Positioned(
      left: note.position?.dx ?? 20,
      top: note.position?.dy ?? 20,
      child: GestureDetector(
        onPanUpdate: isEditing ? (details) {
          Provider.of<NotesProvider>(context, listen: false)
              .updateNotePosition(note.id, Offset(
                (note.position?.dx ?? 0) + details.delta.dx,
                (note.position?.dy ?? 0) + details.delta.dy,
              ));
        } : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Transform.rotate(
              angle: note.rotation ?? 0,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Nota
                  Container(
                    width: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: note.color,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          note.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(note.description),
                        const SizedBox(height: 8),
                        Text(
                          'Fecha: ${DateFormat('dd/MM/yyyy').format(note.deadline)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  // Cinta adhesiva
                  Positioned(
                    top: -70,
                    left: 30,
                    right: 30,
                    child: Transform.rotate(
                      angle: 20.0,
                      child: Image.asset(
                        'assets/images/white-tape-png-41.png',
                        height: 60,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Botón de eliminar
            if (isEditing)
              Positioned(
                top: isNearBottom ? -20 : null,
                bottom: isNearBottom ? null : -20,
                right: -10,
                child: GestureDetector(
                  onTap: () {
                    Provider.of<NotesProvider>(context, listen: false)
                        .deleteNote(note.id);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 