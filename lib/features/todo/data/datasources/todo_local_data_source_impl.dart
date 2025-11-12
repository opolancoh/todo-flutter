import 'package:hive/hive.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/failures.dart';
import '../models/todo_model.dart';
import 'todo_local_data_source.dart';

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final Box<TodoModel> todoBox;

  TodoLocalDataSourceImpl(this.todoBox);

  @override
  Future<List<TodoModel>> getTodos() async {
    try {
      return todoBox.values.toList();
    } catch (e) {
      throw StorageFailure('Failed to get todos: ${e.toString()}');
    }
  }

  @override
  Future<TodoModel> getTodoById(String id) async {
    try {
      final todo = todoBox.get(id);
      if (todo == null) {
        throw NotFoundFailure('Todo with id $id not found');
      }
      return todo;
    } catch (e) {
      if (e is NotFoundFailure) rethrow;
      throw StorageFailure('Failed to get todo: ${e.toString()}');
    }
  }

  @override
  Future<TodoModel> createTodo(TodoModel todo) async {
    try {
      await todoBox.put(todo.id, todo);
      return todo;
    } catch (e) {
      throw StorageFailure('Failed to create todo: ${e.toString()}');
    }
  }

  @override
  Future<TodoModel> updateTodo(TodoModel todo) async {
    try {
      if (!todoBox.containsKey(todo.id)) {
        throw NotFoundFailure('Todo with id ${todo.id} not found');
      }
      await todoBox.put(todo.id, todo);
      return todo;
    } catch (e) {
      if (e is NotFoundFailure) rethrow;
      throw StorageFailure('Failed to update todo: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      if (!todoBox.containsKey(id)) {
        throw NotFoundFailure('Todo with id $id not found');
      }
      await todoBox.delete(id);
    } catch (e) {
      if (e is NotFoundFailure) rethrow;
      throw StorageFailure('Failed to delete todo: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAllTodos() async {
    try {
      await todoBox.clear();
    } catch (e) {
      throw StorageFailure('Failed to delete all todos: ${e.toString()}');
    }
  }
}
