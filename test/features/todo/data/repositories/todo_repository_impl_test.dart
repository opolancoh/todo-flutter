import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_flutter/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:todo_flutter/features/todo/data/models/todo_model.dart';
import 'package:todo_flutter/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo_flutter/features/todo/domain/entities/todo_entity.dart';

class MockTodoLocalDataSource extends Mock implements TodoLocalDataSource {}

void main() {
  late TodoRepositoryImpl repository;
  late MockTodoLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockTodoLocalDataSource();
    repository = TodoRepositoryImpl(mockLocalDataSource);
  });

  setUpAll(() {
    registerFallbackValue(
      const TodoModel(
        id: '1',
        title: 'Test',
        isCompleted: false,
        createdAtMillis: 0,
        updatedAtMillis: 0,
      ),
    );
  });

  group('getTodos', () {
    test('should return list of todos from data source', () async {
      // Arrange
      final testModels = [
        const TodoModel(
          id: '1',
          title: 'Test Todo 1',
          description: 'Description 1',
          isCompleted: false,
          createdAtMillis: 1000000,
          updatedAtMillis: 1000000,
        ),
        const TodoModel(
          id: '2',
          title: 'Test Todo 2',
          description: 'Description 2',
          isCompleted: true,
          createdAtMillis: 2000000,
          updatedAtMillis: 2000000,
        ),
      ];

      when(() => mockLocalDataSource.getTodos())
          .thenAnswer((_) async => testModels);

      // Act
      final result = await repository.getTodos();

      // Assert
      expect(result, isA<List<TodoEntity>>());
      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[0].title, 'Test Todo 1');
      verify(() => mockLocalDataSource.getTodos()).called(1);
    });
  });

  group('createTodo', () {
    test('should create todo and return entity', () async {
      // Arrange
      final testEntity = TodoEntity(
        id: '1',
        title: 'New Todo',
        description: 'New Description',
        isCompleted: false,
        createdAt: DateTime.fromMillisecondsSinceEpoch(1000000),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(1000000),
      );

      final testModel = TodoModel.fromEntity(testEntity);

      when(() => mockLocalDataSource.createTodo(any()))
          .thenAnswer((_) async => testModel);

      // Act
      final result = await repository.createTodo(testEntity);

      // Assert
      expect(result, isA<TodoEntity>());
      expect(result.id, '1');
      expect(result.title, 'New Todo');
      verify(() => mockLocalDataSource.createTodo(any())).called(1);
    });
  });

  group('updateTodo', () {
    test('should update todo and return entity', () async {
      // Arrange
      final testEntity = TodoEntity(
        id: '1',
        title: 'Updated Todo',
        description: 'Updated Description',
        isCompleted: true,
        createdAt: DateTime.fromMillisecondsSinceEpoch(1000000),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(2000000),
      );

      final testModel = TodoModel.fromEntity(testEntity);

      when(() => mockLocalDataSource.updateTodo(any()))
          .thenAnswer((_) async => testModel);

      // Act
      final result = await repository.updateTodo(testEntity);

      // Assert
      expect(result, isA<TodoEntity>());
      expect(result.title, 'Updated Todo');
      expect(result.isCompleted, true);
      verify(() => mockLocalDataSource.updateTodo(any())).called(1);
    });
  });

  group('deleteTodo', () {
    test('should call delete on data source', () async {
      // Arrange
      when(() => mockLocalDataSource.deleteTodo('1'))
          .thenAnswer((_) async {});

      // Act
      await repository.deleteTodo('1');

      // Assert
      verify(() => mockLocalDataSource.deleteTodo('1')).called(1);
    });
  });

  group('deleteAllTodos', () {
    test('should call deleteAll on data source', () async {
      // Arrange
      when(() => mockLocalDataSource.deleteAllTodos())
          .thenAnswer((_) async {});

      // Act
      await repository.deleteAllTodos();

      // Assert
      verify(() => mockLocalDataSource.deleteAllTodos()).called(1);
    });
  });
}
