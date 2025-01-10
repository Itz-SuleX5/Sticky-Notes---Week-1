import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> _notes = [];
  final SharedPreferences _prefs;
  static const String _storageKey = 'notes';
  
  // Referencia de colores para futuros proyectos
  static final List<Color> availableColors = [
    Color(0xFFFFE17D), // Amarillo pastel
    Color(0xFFFFB4B4), // Rosa pastel
    Color(0xFFB4E4B4), // Verde pastel
    Color(0xFFB4D8E4), // Azul claro pastel
  ];

  // Color actual para todas las notas
  static const Color noteColor = Color(0xFFFFE17D);

  NotesProvider(this._prefs) {
    _loadNotes();
  }

  List<Note> get notes => [..._notes];

  void _loadNotes() {
    final String? notesJson = _prefs.getString(_storageKey);
    if (notesJson != null) {
      final List<dynamic> decodedNotes = json.decode(notesJson);
      _notes = decodedNotes.map((note) => Note.fromJson(note)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveNotes() async {
    final String encodedNotes = json.encode(
      _notes.map((note) => note.toJson()).toList(),
    );
    await _prefs.setString(_storageKey, encodedNotes);
  }

  void addNote(String title, String description) {
    // Generar posición aleatoria
    final random = math.Random();
    final position = Offset(
      20 + random.nextDouble() * 200, // Entre 20 y 220
      20 + random.nextDouble() * 300, // Entre 20 y 320
    );
    
    // Generar rotación aleatoria entre -0.1 y 0.1 radianes
    final rotation = (random.nextDouble() * 0.2) - 0.1;

    final newNote = Note(
      id: const Uuid().v4(),
      title: title,
      description: description,
      deadline: DateTime.now(),
      color: noteColor,
      position: position,
      rotation: rotation,
    );
    _notes.add(newNote);
    _saveNotes();
    notifyListeners();
  }

  void updateNote(Note note) {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index >= 0) {
      _notes[index] = note;
      _saveNotes();
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    _saveNotes();
    notifyListeners();
  }

  void updateNotePosition(String id, Offset newPosition) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index >= 0) {
      _notes[index] = _notes[index].copyWith(position: newPosition);
      _saveNotes();
      notifyListeners();
    }
  }

  void updateNoteRotation(String id, double rotation) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index >= 0) {
      _notes[index] = _notes[index].copyWith(rotation: rotation);
      _saveNotes();
      notifyListeners();
    }
  }
} 