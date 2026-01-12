class Todo {
  Todo({required this.name, this.checked = false, this.note});
  
  final String name;
  bool checked;
  String? note;
}