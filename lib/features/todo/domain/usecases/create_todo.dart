import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class CreateTodo {
  final TodoRepository repository;

  CreateTodo(this.repository);

  Future<TodoEntity> call(TodoEntity todo) async {
    return await repository.createTodo(todo);
  }
}
