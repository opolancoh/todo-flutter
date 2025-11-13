import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_flutter/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_flutter/features/todo/domain/usecases/create_todo.dart';
import 'package:todo_flutter/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo_flutter/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_flutter/features/todo/domain/usecases/update_todo.dart';
import 'package:todo_flutter/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_flutter/features/todo/presentation/bloc/todo_event.dart';
import 'package:todo_flutter/features/todo/presentation/bloc/todo_state.dart';

class MockGetTodos extends Mock implements GetTodos {}

class MockCreateTodo extends Mock implements CreateTodo {}

class MockUpdateTodo extends Mock implements UpdateTodo {}

class MockDeleteTodo extends Mock implements DeleteTodo {}

void main() {
  late TodoBloc todoBloc;
  late MockGetTodos mockGetTodos;
  late MockCreateTodo mockCreateTodo;
  late MockUpdateTodo mockUpdateTodo;
  late MockDeleteTodo mockDeleteTodo;

  setUp(() {
    mockGetTodos = MockGetTodos();
    mockCreateTodo = MockCreateTodo();
    mockUpdateTodo = MockUpdateTodo();
    mockDeleteTodo = MockDeleteTodo();

    todoBloc = TodoBloc(
      getTodos: mockGetTodos,
      createTodo: mockCreateTodo,
      updateTodo: mockUpdateTodo,
      deleteTodo: mockDeleteTodo,
    );
  });

  tearDown(() {
    todoBloc.close();
  });

  setUpAll(() {
    registerFallbackValue(
      TodoEntity(
        id: '1',
        title: 'Test',
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  });

  group('TodoBloc', () {
    final testTodos = [
      TodoEntity(
        id: '1',
        title: 'Test Todo 1',
        description: 'Description 1',
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      TodoEntity(
        id: '2',
        title: 'Test Todo 2',
        description: 'Description 2',
        isCompleted: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    test('initial state is TodoInitial', () {
      expect(todoBloc.state, equals(const TodoInitial()));
    });

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoLoaded] when LoadTodos is added and succeeds',
      build: () {
        when(() => mockGetTodos()).thenAnswer((_) async => testTodos);
        return todoBloc;
      },
      act: (bloc) => bloc.add(const LoadTodos()),
      expect: () => [
        const TodoLoading(),
        TodoLoaded(testTodos),
      ],
      verify: (_) {
        verify(() => mockGetTodos()).called(1);
      },
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoError] when LoadTodos is added and fails',
      build: () {
        when(() => mockGetTodos()).thenThrow(Exception('Failed to load todos'));
        return todoBloc;
      },
      act: (bloc) => bloc.add(const LoadTodos()),
      expect: () => [
        const TodoLoading(),
        isA<TodoError>(),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoaded] when AddTodo is added successfully',
      build: () {
        when(() => mockCreateTodo(any())).thenAnswer((_) async => testTodos[0]);
        when(() => mockGetTodos()).thenAnswer((_) async => testTodos);
        return todoBloc;
      },
      act: (bloc) => bloc.add(const AddTodo(title: 'New Todo')),
      expect: () => [
        TodoLoaded(testTodos),
      ],
      verify: (_) {
        verify(() => mockCreateTodo(any())).called(1);
        verify(() => mockGetTodos()).called(1);
      },
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoaded] when ToggleTodoCompletion is added successfully',
      build: () {
        when(() => mockUpdateTodo(any())).thenAnswer((_) async => testTodos[0]);
        when(() => mockGetTodos()).thenAnswer((_) async => testTodos);
        return todoBloc;
      },
      act: (bloc) => bloc.add(ToggleTodoCompletion(testTodos[0])),
      expect: () => [
        TodoLoaded(testTodos),
      ],
      verify: (_) {
        verify(() => mockUpdateTodo(any())).called(1);
        verify(() => mockGetTodos()).called(1);
      },
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoaded] when DeleteTodoEvent is added successfully',
      build: () {
        when(() => mockDeleteTodo('1')).thenAnswer((_) async {});
        when(() => mockGetTodos()).thenAnswer((_) async => []);
        return todoBloc;
      },
      act: (bloc) => bloc.add(const DeleteTodoEvent('1')),
      expect: () => [
        const TodoLoaded([]),
      ],
      verify: (_) {
        verify(() => mockDeleteTodo('1')).called(1);
        verify(() => mockGetTodos()).called(1);
      },
    );
  });
}
