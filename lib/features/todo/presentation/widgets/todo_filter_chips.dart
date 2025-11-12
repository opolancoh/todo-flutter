import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/filter_cubit.dart';

class TodoFilterChips extends StatelessWidget {
  const TodoFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, TodoFilter>(
      builder: (context, currentFilter) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('All'),
                selected: currentFilter == TodoFilter.all,
                onSelected: (_) {
                  context.read<FilterCubit>().setFilter(TodoFilter.all);
                },
              ),
              FilterChip(
                label: const Text('Active'),
                selected: currentFilter == TodoFilter.active,
                onSelected: (_) {
                  context.read<FilterCubit>().setFilter(TodoFilter.active);
                },
              ),
              FilterChip(
                label: const Text('Completed'),
                selected: currentFilter == TodoFilter.completed,
                onSelected: (_) {
                  context.read<FilterCubit>().setFilter(TodoFilter.completed);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
