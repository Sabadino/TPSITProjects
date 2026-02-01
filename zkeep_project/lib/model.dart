class Note {
  Note({required this.title});
  final String title;
}

class Todo {
  Todo({required this.name, required this.checked});
  final String name;
  bool checked;
}