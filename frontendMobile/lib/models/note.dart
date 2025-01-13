import 'package:flutter/material.dart';

class Note {
  final String id;
  String title;
  String description;
  double rotation;
  Offset position;
  bool completed;

  Note({
    required this.id,
    required this.title,
    required this.description,
    this.rotation = 0.0,
    this.position = Offset.zero,
    this.completed = false,
  });

  Color get color => completed ? const Color(0xFFB4E4B4) : const Color(0xFFFFE17D);

  Note copyWith({
    String? title,
    String? description,
    double? rotation,
    Offset? position,
    bool? completed,
  }) {
    return Note(
      id: this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rotation: rotation ?? this.rotation,
      position: position ?? this.position,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'color': completed ? '#B4E4B4' : '#FFE17D',
      'rotation': rotation,
      'position': {'dx': position.dx, 'dy': position.dy},
      'completed': completed,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    final position = json['position'] as Map<String, dynamic>;
    return Note(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'],
      rotation: json['rotation'].toDouble(),
      position: Offset(
        position['dx'].toDouble(),
        position['dy'].toDouble(),
      ),
      completed: json['completed'] ?? false,
    );
  }

  // Método para convertir a JSON para almacenamiento local
  Map<String, dynamic> toLocalJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'color': completed ? '#B4E4B4' : '#FFE17D',
      'rotation': rotation,
      'position': {'dx': position.dx, 'dy': position.dy},
      'completed': completed,
    };
  }
} 