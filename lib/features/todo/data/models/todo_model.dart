import 'package:hive/hive.dart';
import '../../domain/entities/todo_entity.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final int createdAtMillis;

  @HiveField(5)
  final int updatedAtMillis;

  const TodoModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.isCompleted,
    required this.createdAtMillis,
    required this.updatedAtMillis,
  });

  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(createdAtMillis);

  DateTime get updatedAt => DateTime.fromMillisecondsSinceEpoch(updatedAtMillis);

  factory TodoModel.fromEntity(TodoEntity entity) {
    return TodoModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
      createdAtMillis: entity.createdAt.millisecondsSinceEpoch,
      updatedAtMillis: entity.updatedAt.millisecondsSinceEpoch,
    );
  }

  TodoEntity toEntity() {
    return TodoEntity(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAtMillis: createdAt?.millisecondsSinceEpoch ?? createdAtMillis,
      updatedAtMillis: updatedAt?.millisecondsSinceEpoch ?? updatedAtMillis,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAtMillis,
      'updatedAt': updatedAtMillis,
    };
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool,
      createdAtMillis: json['createdAt'] as int,
      updatedAtMillis: json['updatedAt'] as int,
    );
  }
}
