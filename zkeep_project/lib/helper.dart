import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model.dart';

class Helper {
  static const _dbName = 'zkeep.db';
  static const _dbVersion = 1;

  static Future<Database> _open() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE cards (id INTEGER PRIMARY KEY AUTOINCREMENT);');
        await db.execute('''
          CREATE TABLE todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            card_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            checked INTEGER NOT NULL,
            FOREIGN KEY(card_id) REFERENCES cards(id) ON DELETE CASCADE
          );
        ''');
      },
    );
  }

  static Future<void> init() async => _open();

  static Future<List<TodoCard>> getCardsWithTodos() async {
    final db = await _open();
    final cards = <TodoCard>[];
    final cardRows = await db.query('cards');
    for (final row in cardRows) {
      final cardId = row['id'] as int;
      final todoRows = await db.query('todos', where: 'card_id = ?', whereArgs: [cardId]);
      final todos = todoRows.map(Todo.fromMap).toList();
      cards.add(TodoCard(id: cardId, todos: todos));
    }
    return cards;
  }

  static Future<int> insertCard() async {
    final db = await _open();
    return db.rawInsert('INSERT INTO cards DEFAULT VALUES');
  }

  static Future<void> deleteCard(int cardId) async {
    final db = await _open();
    await db.delete('cards', where: 'id = ?', whereArgs: [cardId]);
  }

  static Future<int> insertTodo(Todo todo) async {
    final db = await _open();
    return db.insert('todos', todo.toMap());
  }

  static Future<void> updateTodo(Todo todo) async {
    final db = await _open();
    await db.update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  static Future<void> deleteTodo(int todoId) async {
    final db = await _open();
    await db.delete('todos', where: 'id = ?', whereArgs: [todoId]);
  }
}
