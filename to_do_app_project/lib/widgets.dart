import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'notifier.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<TodoListNotifier>();

    return GestureDetector(
      onLongPress: () {
        notifier.deleteTodo(todo);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Checkbox(
                value: todo.checked,
                onChanged: (_) {
                  notifier.changeTodo(todo);
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  todo.name,
                  style: TextStyle(
                    fontSize: 16,
                    decoration:
                        todo.checked ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
