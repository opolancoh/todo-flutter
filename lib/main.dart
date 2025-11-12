import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'features/todo/presentation/bloc/filter_cubit.dart';
import 'features/todo/presentation/bloc/todo_bloc.dart';
import 'features/todo/presentation/bloc/todo_event.dart';
import 'features/todo/presentation/pages/todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => di.sl<TodoBloc>()..add(const LoadTodos()),
          ),
          BlocProvider(
            create: (context) => di.sl<FilterCubit>(),
          ),
        ],
        child: const TodoPage(),
      ),
    );
  }
}
