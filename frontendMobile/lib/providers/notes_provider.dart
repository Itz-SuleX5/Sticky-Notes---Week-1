import 'dart:convert';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> _notes = [];
  static const String baseUrl = 'https://sticky-notes-week-1.onrender.com';
  static const String _storageKey = 'notes';
  SharedPreferences? _prefs;
  bool _isInitialized = false;
  Timer? _syncTimer;
  
  // Color actual para todas las notas
  static const Color noteColor = Color(0xFFFFE17D);

  NotesProvider() {
    _init();
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      await _loadLocalNotes();
      await _syncWithBackend();
      _isInitialized = true;
      
      _syncTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        _syncWithBackend();
      });
    }
  }

  List<Note> get notes => [..._notes];

  Future<void> _loadLocalNotes() async {
    final String? notesJson = _prefs?.getString(_storageKey);
    if (notesJson != null) {
      final List<dynamic> decodedNotes = json.decode(notesJson);
      _notes = decodedNotes.map((note) => Note.fromJson(note)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveLocalNotes() async {
    final String encodedNotes = json.encode(
      _notes.map((note) => note.toLocalJson()).toList(),
    );
    await _prefs?.setString(_storageKey, encodedNotes);
  }

  Future<void> _syncWithBackend() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/notes/'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedNotes = json.decode(response.body);
        final backendNotes = decodedNotes.map((note) => Note.fromJson(note)).toList();
        
        _notes = backendNotes;
        await _saveLocalNotes();
        notifyListeners();
      }
    } catch (e) {
      print('Error syncing with backend: $e');
    }
  }

  Future<void> addNote(String title, String description) async {
    final random = math.Random();
    final position = {
      'dx': 20 + random.nextDouble() * 200,
      'dy': 20 + random.nextDouble() * 300,
    };
    
    final rotation = (random.nextDouble() * 0.2) - 0.1;

    final noteData = {
      'title': title,
      'description': description,
      'position': position,
      'rotation': rotation,
      'completed': false,
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/notes/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(noteData),
      );

      if (response.statusCode == 201) {
        await _syncWithBackend();
      }
    } catch (e) {
      print('Error adding note: $e');
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/notes/${note.id}/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(note.toJson()),
      );

      if (response.statusCode == 200) {
        await _syncWithBackend();
      }
    } catch (e) {
      print('Error updating note: $e');
      // Actualizar localmente aunque falle el backend
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index >= 0) {
        _notes[index] = note;
        await _saveLocalNotes();
        notifyListeners();
      }
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/notes/$id/'),
      );

      if (response.statusCode == 204) {
        await _syncWithBackend();
      }
    } catch (e) {
      print('Error deleting note: $e');
      // Eliminar localmente aunque falle el backend
      _notes.removeWhere((note) => note.id == id);
      await _saveLocalNotes();
      notifyListeners();
    }
  }

  Future<void> updateNotePosition(String id, Offset newPosition) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index >= 0) {
      final updatedNote = _notes[index].copyWith(
        position: newPosition,
      );
      await updateNote(updatedNote);
    }
  }

  Future<void> updateNoteRotation(String id, double rotation) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index >= 0) {
      final updatedNote = _notes[index].copyWith(
        rotation: rotation,
      );
      await updateNote(updatedNote);
    }
  }

  Future<void> toggleNoteCompleted(String id) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index >= 0) {
      final updatedNote = _notes[index].copyWith(
        completed: !_notes[index].completed,
      );
      await updateNote(updatedNote);
    }
  }
} 