import 'package:equatable/equatable.dart';
import '../../domain/entities/todo_entity.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {
  const LoadTodos();
}

class AddTodo extends TodoEvent {
  final String title;
  final String description;

  const AddTodo({
    required this.title,
    this.description = '',
  });

  @override
  List<Object?> get props => [title, description];
}

class UpdateTodoEvent extends TodoEvent {
  final TodoEntity todo;

  const UpdateTodoEvent(this.todo);

  @override
  List<Object?> get props => [todo];
}

class ToggleTodoCompletion extends TodoEvent {
  final TodoEntity todo;

  const ToggleTodoCompletion(this.todo);

  @override
  List<Object?> get props => [todo];
}

class DeleteTodoEvent extends TodoEvent {
  final String id;

  const DeleteTodoEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteAllTodos extends TodoEvent {
  const DeleteAllTodos();
}

class ClearCompletedTodos extends TodoEvent {
  const ClearCompletedTodos();
}
