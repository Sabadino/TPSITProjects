import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import 'notifier.dart';
import 'widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zkeep',
      theme: ThemeData(
        colorSchemeSeed: Colors.amber,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: ChangeNotifierProvider<NoteNotifier>(
        create: (context) => NoteNotifier(),
        child: const MyHomePage(title: 'zkeep'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayDialog(NoteNotifier notifier) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('aggiungi nota'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'scrivi qui ...'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('aggiungi'),
              onPressed: () {
                Navigator.of(context).pop();
                notifier.addNote(_textFieldController.text);
                _textFieldController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final NoteNotifier notifier = context.watch<NoteNotifier>();

    return Scaffold(
      appBar: AppBar(
        shadowColor: Theme.of(context).shadowColor,
        elevation: 4,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: notifier.length,
          itemBuilder: (context, index) {
            Note note = notifier.getNote(index);
            return NoteItem(note: note);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(notifier),
        tooltip: 'aggiungi nota',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key, required this.note});
  final Note note;

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayDialog(TodoNotifier notifier) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('aggiungi todo'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'scrivi qui ...'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('aggiungi'),
              onPressed: () {
                Navigator.of(context).pop();
                notifier.addTodo(_textFieldController.text);
                _textFieldController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TodoNotifier notifier = context.watch<TodoNotifier>();

    return Scaffold(
      appBar: AppBar(
        shadowColor: Theme.of(context).shadowColor,
        elevation: 4,
        title: Text(widget.note.title),
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: notifier.length,
          itemBuilder: (context, index) {
            Todo todo = notifier.getTodo(index);
            return TodoItem(todo: todo);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(notifier),
        tooltip: 'aggiungi todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}