import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final bool isEditing;

  const NoteCard({
    Key? key,
    required this.note,
    required this.isEditing,
  }) : super(key: key);

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  Offset? _dragOffset;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(8.0),
          child: Transform.translate(
            offset: Offset(widget.note.position['dx'], widget.note.position['dy']),
            child: Transform.rotate(
              angle: widget.note.rotation,
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: widget.note.completed ? const Color(0xFFB4E4B4) : const Color(0xFFFFE17D),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/tape.png',
                      width: 60,
                      height: 30,
                    ),
                    Text(
                      widget.note.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: widget.note.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.note.description,
                      style: TextStyle(
                        decoration: widget.note.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Switch(
                          value: widget.note.completed,
                          onChanged: (bool value) {
                            widget.onUpdate(
                              widget.note.copyWith(completed: value),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => widget.onDelete(widget.note),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 