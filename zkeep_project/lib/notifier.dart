import 'package:flutter/widgets.dart';

import 'helper.dart';
import 'model.dart';

class TodoListNotifier with ChangeNotifier {
  final _cards = <TodoCard>[];

  int get length => _cards.length;

  Future<void> loadFromDb() async {
    await DatabaseHelper.init();
    List<TodoCard> notes = await DatabaseHelper.getNotes();
    List<Todo> todos = await DatabaseHelper.getTodos();

    for (TodoCard card in notes) {
      for (Todo todo in todos) {
        if (todo.noteId == card.id) {
          card.todos.add(todo);
        }
      }
    }

    _cards.clear();
    _cards.addAll(notes);
    notifyListeners();
  }

  Future<void> addCard() async {
    int newId = await DatabaseHelper.insertNote();
    _cards.add(TodoCard(id: newId));
    notifyListeners();
  }

  Future<void> addTodo(String name, int cardID) async {
    Todo todo = Todo(noteId: cardID, name: name, checked: false);
    todo.id = await DatabaseHelper.insertTodo(todo);

    for (TodoCard card in _cards) {
      if (card.id == cardID) {
        card.todos.add(todo);
        break;
      }
    }
    notifyListeners();
  }

  Future<void> changeTodo(Todo todo) async {
    todo.checked = !todo.checked;
    await DatabaseHelper.updateTodo(todo);
    notifyListeners();
  }

  Future<void> editTodo(Todo todo, String newName) async {
    todo.name = newName;
    await DatabaseHelper.updateTodo(todo);
  }

  Future<void> deleteTodo(Todo todo, int cardID) async {
    await DatabaseHelper.deleteTodo(todo);
    for (TodoCard card in _cards) {
      if (card.id == cardID) {
        card.todos.remove(todo);
        break;
      }
    }
    notifyListeners();
  }

  Future<void> deleteCard(int cardID) async {
    await DatabaseHelper.deleteNote(cardID);
    for (int i = 0; i < _cards.length; i++) {
      if (_cards[i].id == cardID) {
        _cards.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }

  TodoCard getCard(int index) => _cards[index];

  List<TodoCard> get cards => _cards;
}
