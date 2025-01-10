import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import 'package:provider/provider.dart';

class NoteCard extends StatefulWidget {
  final Note note;

  const NoteCard({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  late Offset _position;
  late double _rotation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _position = widget.note.position;
    _rotation = widget.note.rotation;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
            Provider.of<NotesProvider>(context, listen: false)
                .updateNotePosition(widget.note.id, _position);
          });
        },
        onLongPress: _showEditDialog,
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Transform.rotate(
          angle: _rotation,
          child: Dismissible(
            key: Key(widget.note.id),
            direction: DismissDirection.up,
            onDismissed: (_) {
              Provider.of<NotesProvider>(context, listen: false)
                  .deleteNote(widget.note.id);
            },
            child: Container(
              width: _isExpanded ? 250 : 200,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: widget.note.color,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5.0,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.note.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.note.description,
                    maxLines: _isExpanded ? null : 3,
                    overflow: _isExpanded ? null : TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fecha límite: ${DateFormat('dd/MM/yyyy').format(widget.note.deadline)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String title = widget.note.title;
        String description = widget.note.description;
        DateTime deadline = widget.note.deadline;
        Color color = widget.note.color;

        return AlertDialog(
          title: const Text('Editar Nota'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Título'),
                  controller: TextEditingController(text: title),
                  onChanged: (value) => title = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  controller: TextEditingController(text: description),
                  maxLines: 3,
                  onChanged: (value) => description = value,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: Provider.of<NotesProvider>(context)
                      .noteColors
                      .map((c) => GestureDetector(
                            onTap: () => color = c,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                                border: c == color
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
                final updatedNote = widget.note.copyWith(
                  title: title,
                  description: description,
                  deadline: deadline,
                  color: color,
                );
                Provider.of<NotesProvider>(context, listen: false)
                    .updateNote(updatedNote);
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
} 