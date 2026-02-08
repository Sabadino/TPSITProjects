import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'notifier.dart';

class TodoCardWidget extends StatefulWidget {
  const TodoCardWidget({super.key, required this.card});
  final TodoCard card;

  @override
  State<TodoCardWidget> createState() => _TodoCardWidgetState();
}

class _TodoCardWidgetState extends State<TodoCardWidget> {
  final TextEditingController _todoController = TextEditingController();
  bool _showInput = false;

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  Future<void> _addTodo(TodoListNotifier notifier) async {
    await notifier.addTodo(_todoController.text, widget.card.id);
    _todoController.clear();
    setState(() {
      _showInput = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<TodoListNotifier>();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...widget.card.todos.map(
              (todo) => TodoItem(todo: todo, cardId: widget.card.id),
            ),
            if (_showInput)
              Row(
                children: [
                  const Checkbox(value: false, onChanged: null),
                  Expanded(
                    child: TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                        hintText: 'Nuovo elemento...',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      autofocus: true,
                      onSubmitted: (_) => _addTodo(notifier),
                    ),
                  ),
                ],
              ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Colors.amber[700]),
                  onPressed: () {
                    setState(() {
                      _showInput = true;
                    });
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: () => notifier.deleteCard(widget.card.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TodoItem extends StatefulWidget {
  const TodoItem({super.key, required this.todo, required this.cardId});

  final Todo todo;
  final int cardId;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.todo.name);
  }

  @override
  void didUpdateWidget(covariant TodoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.todo.id != widget.todo.id) {
      _controller.text = widget.todo.name;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextStyle? _style(bool checked) {
    if (!checked) return null;
    return const TextStyle(
      color: Colors.black45,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<TodoListNotifier>();

    return Row(
      children: [
        Checkbox(
          value: widget.todo.checked,
          onChanged: (_) => notifier.changeTodo(widget.todo),
          activeColor: Colors.amber[700],
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            style: _style(widget.todo.checked),
            onChanged: (value) => notifier.editTodo(widget.todo, value),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 18, color: Colors.grey),
          onPressed: () => notifier.deleteTodo(widget.todo, widget.cardId),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
