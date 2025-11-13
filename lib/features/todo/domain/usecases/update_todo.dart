import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class UpdateTodo {
  final TodoRepository repository;

  UpdateTodo(this.repository);

  Future<TodoEntity> call(TodoEntity todo) async {
    return await repository.updateTodo(todo);
  }
}
