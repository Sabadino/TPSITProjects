import 'package:flutter/widgets.dart';
import 'model.dart';

class NoteNotifier with ChangeNotifier {
  final _notes = <Note>[];

  int get length => _notes.length;

  void addNote(String title) {
    _notes.add(Note(title: title));
    notifyListeners();
  }

  void deleteNote(Note note) {
    _notes.remove(note);
    notifyListeners();
  }

  Note getNote(int i) => _notes[i];
}

class TodoNotifier with ChangeNotifier {
  final _todos = <Todo>[];

  int get length => _todos.length;

  void addTodo(String name) {
    _todos.add(Todo(name: name, checked: false));
    notifyListeners();
  }

  void changeTodo(Todo todo) {
    todo.checked = !todo.checked;
    notifyListeners();
  }

  void deleteTodo(Todo todo) {
    _todos.remove(todo);
    notifyListeners();
  }

  Todo getTodo(int i) => _todos[i];
}