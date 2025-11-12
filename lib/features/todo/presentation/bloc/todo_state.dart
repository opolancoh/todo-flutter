import 'package:equatable/equatable.dart';
import '../../domain/entities/todo_entity.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {
  const TodoInitial();
}

class TodoLoading extends TodoState {
  const TodoLoading();
}

class TodoLoaded extends TodoState {
  final List<TodoEntity> todos;

  const TodoLoaded(this.todos);

  @override
  List<Object?> get props => [todos];

  int get totalCount => todos.length;
  int get activeCount => todos.where((todo) => !todo.isCompleted).length;
  int get completedCount => todos.where((todo) => todo.isCompleted).length;
}

class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);

  @override
  List<Object?> get props => [message];
}
