import 'package:flutter/material.dart';
import 'model.dart';
import 'main.dart';

class NoteItem extends StatelessWidget {
  NoteItem({
    required this.note,
    required this.onNoteDelete,
  }) : super(key: ObjectKey(note));

  final Note note;
  final Function onNoteDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoPage(note: note),
          ),
        );
      },
      onLongPress: (() {
        onNoteDelete(note);
      }),
      leading: CircleAvatar(child: Text(note.title[0])),
      title: Text(note.title),
    );
  }
}

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
    required this.onTodoDelete,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final Function onTodoChanged;
  final Function onTodoDelete;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;
    return const TextStyle(
      color: Colors.black45,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChanged(todo);
      },
      onLongPress: (() {
        onTodoDelete(todo);
      }),
      leading: CircleAvatar(child: Text(todo.name[0])),
      title: Text(todo.name, style: _getTextStyle(todo.checked)),
    );
  }
}