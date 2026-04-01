import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'notifier.dart';

class TodoCardWidget extends StatefulWidget{
  const TodoCardWidget({super.key, required this.card});

  final TodoCard card;

  @override
  State<TodoCardWidget> createState() => _TodoCardWidgetState();
}

class _TodoCardWidgetState extends State<TodoCardWidget>{
  final TextEditingController _todoController = TextEditingController();
  bool _showNewTodoField = false;

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  void _addTodo(TodoListNotifier notifier) {
    if (_todoController.text.isNotEmpty) {
      notifier.addTodo(_todoController.text, widget.card.id);
      _todoController.clear();
      setState(() {
        _showNewTodoField = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TodoListNotifier notifier = context.watch<TodoListNotifier>();

    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...widget.card.todos.map((todo) {
              return TodoItem(
                todo: todo,
                cardId: widget.card.id,
              );
            }),
            if (_showNewTodoField)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: false,
                      onChanged: null,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _todoController,
                        decoration: const InputDecoration(
                          hintText: 'Nuovo elemento...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        autofocus: true,
                        onSubmitted: (value) => _addTodo(notifier),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.amber[700],
                    ),
                    onPressed: () {
                      setState(() {
                        _showNewTodoField = true;
                      });
                    },
                    tooltip: 'Aggiungi promemoria',
                    iconSize: 22,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      notifier.deleteCard(widget.card.id);
                    },
                    tooltip: 'Elimina nota',
                    iconSize: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  TodoItem({required this.todo, required this.cardId}) : super(key: ObjectKey(todo));

  final int cardId;
  final Todo todo;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black45,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TodoListNotifier notifier = context.watch<TodoListNotifier>();
    final TextEditingController controller = TextEditingController(text: todo.name);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Checkbox(
            value: todo.checked,
            onChanged: (value) {
              notifier.changeTodo(todo);
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            activeColor: Colors.amber[700],
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
              style: _getTextStyle(todo.checked),
              onChanged: (value) {
                notifier.editTodo(todo, value);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
            onPressed: () {
              notifier.deleteTodo(todo, cardId);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
