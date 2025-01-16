import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final bool isEditing;
  final Function(Note) onUpdate;
  final Function(Note) onDelete;

  const NoteCard({
    Key? key,
    required this.note,
    required this.isEditing,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  late Offset _position;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _position = widget.note.position;
  }

  @override
  void didUpdateWidget(NoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.note.position != widget.note.position) {
      _position = widget.note.position;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanStart: widget.isEditing ? null : (_) {
          setState(() {
            _isDragging = true;
          });
        },
        onPanUpdate: widget.isEditing ? null : (details) {
          setState(() {
            _position += details.delta;
          });
        },
        onPanEnd: widget.isEditing ? null : (_) {
          setState(() {
            _isDragging = false;
            widget.onUpdate(
              widget.note.copyWith(position: _position),
            );
          });
        },
        child: Container(
          width: 200,
          margin: const EdgeInsets.all(8.0),
          child: Transform.rotate(
            angle: widget.note.rotation,
            child: Material(
              elevation: _isDragging ? 8.0 : 4.0,
              borderRadius: BorderRadius.circular(8.0),
              color: widget.note.completed ? const Color(0xFFB4E4B4) : const Color(0xFFFFE17D),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/white-tape-png-41.png',
                      width: 60,
                      height: 30,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          width: 60,
                          height: 30,
                        );
                      },
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
                          onChanged: widget.isEditing ? null : (bool value) {
                            widget.onUpdate(
                              widget.note.copyWith(completed: value),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: widget.isEditing ? null : () => widget.onDelete(widget.note),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 