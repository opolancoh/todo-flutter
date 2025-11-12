import 'package:hive/hive.dart';
import '../../domain/entities/todo_entity.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends TodoEntity {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String title;

  @HiveField(2)
  @override
  final String description;

  @HiveField(3)
  @override
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
  }) : super(
          id: id,
          title: title,
          description: description,
          isCompleted: isCompleted,
          createdAt: const _DummyDateTime(),
          updatedAt: const _DummyDateTime(),
        );

  @override
  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(createdAtMillis);

  @override
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

  @override
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
      createdAtMillis: createdAt?.millisecondsSinceEpoch ?? this.createdAtMillis,
      updatedAtMillis: updatedAt?.millisecondsSinceEpoch ?? this.updatedAtMillis,
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

// Dummy DateTime class for const constructor
class _DummyDateTime implements DateTime {
  const _DummyDateTime();

  @override
  DateTime add(Duration duration) => throw UnimplementedError();

  @override
  int compareTo(DateTime other) => throw UnimplementedError();

  @override
  int get day => throw UnimplementedError();

  @override
  Difference difference(DateTime other) => throw UnimplementedError();

  @override
  int get hour => throw UnimplementedError();

  @override
  bool isAfter(DateTime other) => throw UnimplementedError();

  @override
  bool isAtSameMomentAs(DateTime other) => throw UnimplementedError();

  @override
  bool isBefore(DateTime other) => throw UnimplementedError();

  @override
  bool get isUtc => throw UnimplementedError();

  @override
  int get microsecond => throw UnimplementedError();

  @override
  int get microsecondsSinceEpoch => throw UnimplementedError();

  @override
  int get millisecond => throw UnimplementedError();

  @override
  int get millisecondsSinceEpoch => throw UnimplementedError();

  @override
  int get minute => throw UnimplementedError();

  @override
  int get month => throw UnimplementedError();

  @override
  int get second => throw UnimplementedError();

  @override
  Duration get timeZoneOffset => throw UnimplementedError();

  @override
  String get timeZoneName => throw UnimplementedError();

  @override
  DateTime toLocal() => throw UnimplementedError();

  @override
  String toIso8601String() => throw UnimplementedError();

  @override
  DateTime toUtc() => throw UnimplementedError();

  @override
  int get weekday => throw UnimplementedError();

  @override
  int get year => throw UnimplementedError();

  @override
  DateTime subtract(Duration duration) => throw UnimplementedError();
}
