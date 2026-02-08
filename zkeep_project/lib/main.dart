import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helper.dart';
import 'model.dart';
import 'notifier.dart';
import 'widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Helper.init();
  final initialCards = await Helper.getCardsWithTodos();
  runApp(MyApp(initialCards: initialCards));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialCards});
  final List<TodoCard> initialCards;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZKEEP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (_) => TodoListNotifier(initialCards),
        child: const MyHomePage(title: 'ZKEEP'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final n = context.watch<TodoListNotifier>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: n.length == 0
            ? const Center(child: Text('Nessuna nota'))
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: n.length,
                itemBuilder: (_, i) => TodoCardWidget(card: n.getCard(i)),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: n.addCard,
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
