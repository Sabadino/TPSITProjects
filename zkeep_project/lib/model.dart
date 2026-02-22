class Todo {
  Todo({this.id, required this.noteId, required this.name, required this.checked});
  int? id;
  final int noteId;
  String name;
  bool checked;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'note_id': noteId,
      'name': name,
      'checked': checked ? 1 : 0,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static Todo fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      noteId: map['note_id'],
      name: map['name'],
      checked: map['checked'] == 1,
    );
  }
}

class TodoCard {
  TodoCard({required this.id});
  final int id;
  List<Todo> todos = [];

  static TodoCard fromMap(Map<String, dynamic> map) {
    return TodoCard(id: map['id']);
  }
}
