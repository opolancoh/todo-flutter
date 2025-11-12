import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/todo_entity.dart';
import '../bloc/filter_cubit.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/todo_filter_chips.dart';
import '../widgets/todo_list_item.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear_completed') {
                context.read<TodoBloc>().add(const ClearCompletedTodos());
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_completed',
                child: Text('Clear Completed'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const TodoFilterChips(),
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is TodoLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${state.activeCount} active',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${state.completedCount} completed',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const Divider(),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, todoState) {
                if (todoState is TodoLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (todoState is TodoError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: ${todoState.message}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<TodoBloc>().add(const LoadTodos());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (todoState is TodoLoaded) {
                  return BlocBuilder<FilterCubit, TodoFilter>(
                    builder: (context, filter) {
                      final filteredTodos = _getFilteredTodos(todoState.todos, filter);

                      if (filteredTodos.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _getEmptyMessage(filter),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredTodos.length,
                        itemBuilder: (context, index) {
                          return TodoListItem(todo: filteredTodos[index]);
                        },
                      );
                    },
                  );
                }

                return const Center(
                  child: Text('Start by adding your first todo!'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<TodoBloc>(),
              child: const AddTodoDialog(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<TodoEntity> _getFilteredTodos(List<TodoEntity> todos, TodoFilter filter) {
    switch (filter) {
      case TodoFilter.active:
        return todos.where((todo) => !todo.isCompleted).toList();
      case TodoFilter.completed:
        return todos.where((todo) => todo.isCompleted).toList();
      case TodoFilter.all:
      default:
        return todos;
    }
  }

  String _getEmptyMessage(TodoFilter filter) {
    switch (filter) {
      case TodoFilter.active:
        return 'No active todos';
      case TodoFilter.completed:
        return 'No completed todos';
      case TodoFilter.all:
      default:
        return 'No todos yet';
    }
  }
}
