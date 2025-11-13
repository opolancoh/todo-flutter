import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_flutter/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_flutter/features/todo/presentation/bloc/filter_cubit.dart';
import 'package:todo_flutter/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_flutter/features/todo/presentation/bloc/todo_state.dart';
import 'package:todo_flutter/features/todo/presentation/pages/todo_page.dart';

class MockTodoBloc extends Mock implements TodoBloc {}

class MockFilterCubit extends Mock implements FilterCubit {}

void main() {
  late MockTodoBloc mockTodoBloc;
  late MockFilterCubit mockFilterCubit;

  setUp(() {
    mockTodoBloc = MockTodoBloc();
    mockFilterCubit = MockFilterCubit();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TodoBloc>.value(value: mockTodoBloc),
          BlocProvider<FilterCubit>.value(value: mockFilterCubit),
        ],
        child: const TodoPage(),
      ),
    );
  }

  testWidgets('displays loading indicator when state is TodoLoading',
      (WidgetTester tester) async {
    when(() => mockTodoBloc.state).thenReturn(const TodoLoading());
    when(() => mockTodoBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockFilterCubit.state).thenReturn(TodoFilter.all);
    when(() => mockFilterCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays empty message when no todos',
      (WidgetTester tester) async {
    when(() => mockTodoBloc.state).thenReturn(const TodoLoaded([]));
    when(() => mockTodoBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockFilterCubit.state).thenReturn(TodoFilter.all);
    when(() => mockFilterCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('No todos yet'), findsOneWidget);
  });

  testWidgets('displays todo list when state is TodoLoaded with todos',
      (WidgetTester tester) async {
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

    when(() => mockTodoBloc.state).thenReturn(TodoLoaded(testTodos));
    when(() => mockTodoBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockFilterCubit.state).thenReturn(TodoFilter.all);
    when(() => mockFilterCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Test Todo 1'), findsOneWidget);
    expect(find.text('Test Todo 2'), findsOneWidget);
  });

  testWidgets('displays floating action button',
      (WidgetTester tester) async {
    when(() => mockTodoBloc.state).thenReturn(const TodoLoaded([]));
    when(() => mockTodoBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockFilterCubit.state).thenReturn(TodoFilter.all);
    when(() => mockFilterCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('shows error message when state is TodoError',
      (WidgetTester tester) async {
    when(() => mockTodoBloc.state)
        .thenReturn(const TodoError('Something went wrong'));
    when(() => mockTodoBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockFilterCubit.state).thenReturn(TodoFilter.all);
    when(() => mockFilterCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Error: Something went wrong'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
