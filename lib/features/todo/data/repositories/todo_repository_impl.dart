import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_data_source.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl(this.localDataSource);

  @override
  Future<List<TodoEntity>> getTodos() async {
    final todos = await localDataSource.getTodos();
    return todos.map((model) => model.toEntity()).toList();
  }

  @override
  Future<TodoEntity> getTodoById(String id) async {
    final todo = await localDataSource.getTodoById(id);
    return todo.toEntity();
  }

  @override
  Future<TodoEntity> createTodo(TodoEntity todo) async {
    final model = TodoModel.fromEntity(todo);
    final createdModel = await localDataSource.createTodo(model);
    return createdModel.toEntity();
  }

  @override
  Future<TodoEntity> updateTodo(TodoEntity todo) async {
    final model = TodoModel.fromEntity(todo);
    final updatedModel = await localDataSource.updateTodo(model);
    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteTodo(String id) async {
    await localDataSource.deleteTodo(id);
  }

  @override
  Future<void> deleteAllTodos() async {
    await localDataSource.deleteAllTodos();
  }
}
