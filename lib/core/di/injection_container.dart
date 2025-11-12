import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/todo/data/datasources/todo_local_data_source.dart';
import '../../features/todo/data/datasources/todo_local_data_source_impl.dart';
import '../../features/todo/data/models/todo_model.dart';
import '../../features/todo/data/repositories/todo_repository_impl.dart';
import '../../features/todo/domain/repositories/todo_repository.dart';
import '../../features/todo/domain/usecases/create_todo.dart';
import '../../features/todo/domain/usecases/delete_todo.dart';
import '../../features/todo/domain/usecases/get_todos.dart';
import '../../features/todo/domain/usecases/update_todo.dart';
import '../../features/todo/presentation/bloc/filter_cubit.dart';
import '../../features/todo/presentation/bloc/todo_bloc.dart';
import '../constants/constants.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  final todoBox = await Hive.openBox<TodoModel>(StorageConstants.todoBoxName);

  // External
  sl.registerLazySingleton<Box<TodoModel>>(() => todoBox);

  // Data sources
  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTodos(sl()));
  sl.registerLazySingleton(() => CreateTodo(sl()));
  sl.registerLazySingleton(() => UpdateTodo(sl()));
  sl.registerLazySingleton(() => DeleteTodo(sl()));

  // BLoC / Cubit
  sl.registerFactory(
    () => TodoBloc(
      getTodos: sl(),
      createTodo: sl(),
      updateTodo: sl(),
      deleteTodo: sl(),
    ),
  );

  sl.registerFactory(() => FilterCubit());
}
