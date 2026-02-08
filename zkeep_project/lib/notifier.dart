import 'package:flutter/widgets.dart';
import 'helper.dart';
import 'model.dart';

class TodoListNotifier with ChangeNotifier {
  TodoListNotifier(List<TodoCard> initialCards) : _cards = initialCards;
  final List<TodoCard> _cards;

  int get length => _cards.length;
  TodoCard getCard(int i) => _cards[i];

  Future<void> addCard() async {
    final id = await Helper.insertCard();
    _cards.add(TodoCard(id: id));
    notifyListeners();
  }

  Future<void> deleteCard(int cardId) async {
    _cards.removeWhere((c) => c.id == cardId);
    notifyListeners();
    await Helper.deleteCard(cardId);
  }

  Future<void> addTodo(String name, int cardId) async {
    if (name.isEmpty) return;
    final todo = Todo(cardId: cardId, name: name);
    todo.id = await Helper.insertTodo(todo);
    _cards.firstWhere((c) => c.id == cardId).todos.add(todo);
    notifyListeners();
  }

  Future<void> changeTodo(Todo todo) async {
    todo.checked = !todo.checked;
    notifyListeners();
    await Helper.updateTodo(todo);
  }

  Future<void> editTodo(Todo todo, String newName) async {
    if (newName.isEmpty) return;
    todo.name = newName;
    notifyListeners();
    await Helper.updateTodo(todo);
  }

  Future<void> deleteTodo(Todo todo, int cardId) async {
    _cards.firstWhere((c) => c.id == cardId).todos.remove(todo);
    notifyListeners();
    if (todo.id != null) await Helper.deleteTodo(todo.id!);
  }
}
