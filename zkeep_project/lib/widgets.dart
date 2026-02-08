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
  final _ctrl = TextEditingController();
  bool _showInput = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _add(TodoListNotifier n) async {
    await n.addTodo(_ctrl.text, widget.card.id);
    _ctrl.clear();
    setState(() => _showInput = false);
  }

  @override
  Widget build(BuildContext context) {
    final n = context.watch<TodoListNotifier>();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...widget.card.todos.map((t) => TodoItem(todo: t, cardId: widget.card.id)),
            if (_showInput)
              Row(
                children: [
                  const Checkbox(value: false, onChanged: null),
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      decoration: const InputDecoration(
                        hintText: 'Nuovo elemento...',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onSubmitted: (_) => _add(n),
                    ),
                  ),
                ],
              ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Colors.amber[700]),
                  onPressed: () => setState(() => _showInput = true),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: () => n.deleteCard(widget.card.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  TodoItem({super.key, required this.todo, required this.cardId});
  final Todo todo;
  final int cardId;

  TextStyle? _style(bool checked) =>
      checked ? const TextStyle(color: Colors.black45, decoration: TextDecoration.lineThrough) : null;

  @override
  Widget build(BuildContext context) {
    final n = context.watch<TodoListNotifier>();
    final c = TextEditingController(text: todo.name);

    return Row(
      children: [
        Checkbox(
          value: todo.checked,
          onChanged: (_) => n.changeTodo(todo),
          activeColor: Colors.amber[700],
        ),
        Expanded(
          child: TextField(
            controller: c,
            decoration: const InputDecoration(border: InputBorder.none, isDense: true),
            style: _style(todo.checked),
            onChanged: (v) => n.editTodo(todo, v),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 18, color: Colors.grey),
          onPressed: () => n.deleteTodo(todo, cardId),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
