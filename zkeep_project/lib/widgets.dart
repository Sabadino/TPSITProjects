import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import 'notifier.dart';
import 'main.dart';

class NoteItem extends StatelessWidget {
  NoteItem({required this.note}) : super(key: ObjectKey(note));
  final Note note;

  @override
  Widget build(BuildContext context) {
    final NoteNotifier notifier = context.watch<NoteNotifier>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider<TodoNotifier>(
                        create: (context) => TodoNotifier(),
                        child: TodoPage(note: note),
                      ),
                    ),
                  );
                },
                onLongPress: () => notifier.deleteNote(note),
                child: Text(note.title),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  TodoItem({required this.todo}) : super(key: ObjectKey(todo));
  final Todo todo;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;
    return const TextStyle(
      color: Colors.white70,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TodoNotifier notifier = context.watch<TodoNotifier>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Checkbox(
              value: todo.checked,
              onChanged: (_) => notifier.changeTodo(todo),
            ),
            Expanded(
              child: GestureDetector(
                onLongPress: () => notifier.deleteTodo(todo),
                child: Text(todo.name, style: _getTextStyle(todo.checked)),
              ),
            )
          ],
        ),
      ),
    );
  }
}