import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/create_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/update_todo.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final CreateTodo createTodo;
  final UpdateTodo updateTodo;
  final DeleteTodo deleteTodo;
  final Uuid uuid = const Uuid();

  TodoBloc({
    required this.getTodos,
    required this.createTodo,
    required this.updateTodo,
    required this.deleteTodo,
  }) : super(const TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<ToggleTodoCompletion>(_onToggleTodoCompletion);
    on<DeleteTodoEvent>(_onDeleteTodo);
    on<ClearCompletedTodos>(_onClearCompletedTodos);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(const TodoLoading());
    try {
      final todos = await getTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      final now = DateTime.now();
      final newTodo = TodoEntity(
        id: uuid.v4(),
        title: event.title,
        description: event.description,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      await createTodo(newTodo);
      final todos = await getTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onUpdateTodo(
      UpdateTodoEvent event, Emitter<TodoState> emit) async {
    try {
      final updatedTodo = event.todo.copyWith(
        updatedAt: DateTime.now(),
      );
      await updateTodo(updatedTodo);
      final todos = await getTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onToggleTodoCompletion(
      ToggleTodoCompletion event, Emitter<TodoState> emit) async {
    try {
      final updatedTodo = event.todo.copyWith(
        isCompleted: !event.todo.isCompleted,
        updatedAt: DateTime.now(),
      );
      await updateTodo(updatedTodo);
      final todos = await getTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onDeleteTodo(
      DeleteTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await deleteTodo(event.id);
      final todos = await getTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onClearCompletedTodos(
      ClearCompletedTodos event, Emitter<TodoState> emit) async {
    try {
      if (state is TodoLoaded) {
        final currentTodos = (state as TodoLoaded).todos;
        final completedTodos =
            currentTodos.where((todo) => todo.isCompleted).toList();

        for (final todo in completedTodos) {
          await deleteTodo(todo.id);
        }

        final todos = await getTodos();
        emit(TodoLoaded(todos));
      }
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
}
