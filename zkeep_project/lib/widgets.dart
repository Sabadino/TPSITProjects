import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import 'notifier.dart';

// Card nella griglia principale
class TodoCardWidget extends StatelessWidget {
  final TodoCard card;
  const TodoCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EditNoteScreen(card: card)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (card.title.isNotEmpty) ...[
              Text(
                card.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
            ],
            ...card.lines.take(6).map((line) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        line.checked
                            ? Icons.check_circle_outline
                            : Icons.radio_button_unchecked,
                        size: 13,
                        color: line.checked
                            ? const Color(0xFFF57C00)
                            : Colors.grey.shade400,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          line.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: line.checked
                                ? Colors.grey.shade400
                                : Colors.black87,
                            decoration: line.checked
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            if (card.lines.length > 6)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '+ altri ${card.lines.length - 6}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Schermata di modifica nota
class EditNoteScreen extends StatelessWidget {
  final TodoCard card;
  const EditNoteScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<TodoBoardNotifier>();

    return Scaffold(
      backgroundColor: const Color(0xFFE8EAF6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF57C00),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Elimina nota',
            onPressed: () {
              notifier.deleteCard(card);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          TextFormField(
            initialValue: card.title,
            decoration: const InputDecoration(
              hintText: 'Titolo',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey),
            ),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (v) => notifier.updateTitle(card, v),
          ),
          const Divider(),
          const SizedBox(height: 4),
          ...card.lines.map((line) => _LineItem(card: card, line: line)),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => notifier.addLine(card),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Aggiungi elemento'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFF57C00),
              alignment: Alignment.centerLeft,
            ),
          ),
        ],
      ),
    );
  }
}

class _LineItem extends StatelessWidget {
  final TodoCard card;
  final TodoLine line;
  const _LineItem({required this.card, required this.line});

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<TodoBoardNotifier>();

    return Row(
      children: [
        Checkbox(
          value: line.checked,
          onChanged: (_) => notifier.toggleLine(line),
          activeColor: const Color(0xFFF57C00),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        Expanded(
          child: TextFormField(
            initialValue: line.text,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            style: TextStyle(
              decoration: line.checked ? TextDecoration.lineThrough : null,
              color: line.checked ? Colors.grey : Colors.black87,
            ),
            onChanged: (v) => notifier.updateLine(line, v),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 16),
          color: Colors.grey.shade400,
          onPressed: () => notifier.deleteLine(card, line),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
