class Todo {
  Todo({required this.cardId, required this.name, this.id, this.checked = false});

  int? id;
  final int cardId;
  String name;
  bool checked;

  Map<String, dynamic> toMap() => {
        'id': id,
        'card_id': cardId,
        'name': name,
        'checked': checked ? 1 : 0,
      };

  factory Todo.fromMap(Map<String, dynamic> map) => Todo(
        id: map['id'] as int?,
        cardId: map['card_id'] as int,
        name: map['name'] as String,
        checked: (map['checked'] as int) == 1,
      );
}

class TodoCard {
  TodoCard({required this.id, List<Todo>? todos}) : todos = todos ?? [];
  final int id;
  final List<Todo> todos;
}
