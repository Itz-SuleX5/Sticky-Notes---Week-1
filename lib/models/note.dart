import 'package:flutter/material.dart';

class Note {
  final String id;
  String title;
  String description;
  DateTime deadline;
  Color color;
  double rotation;
  Offset position;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.color,
    this.rotation = 0.0,
    this.position = Offset.zero,
  });

  Note copyWith({
    String? title,
    String? description,
    DateTime? deadline,
    Color? color,
    double? rotation,
    Offset? position,
  }) {
    return Note(
      id: this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      color: color ?? this.color,
      rotation: rotation ?? this.rotation,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'color': color.value,
      'rotation': rotation,
      'position': {'dx': position.dx, 'dy': position.dy},
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      color: Color(json['color']),
      rotation: json['rotation'],
      position: Offset(json['position']['dx'], json['position']['dy']),
    );
  }
} 