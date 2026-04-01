import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

class DatabaseHelper {
  static Future<Database> init() async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  static Future<void> _createTable(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notes (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
    );
    ''');
    await db.execute('''
    CREATE TABLE todos (
      id      INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      note_id INTEGER NOT NULL,
      name    TEXT    NOT NULL,
      checked INTEGER NOT NULL
    );
    ''');
  }

  static Future<List<TodoCard>> getNotes() async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    final List<Map<String, dynamic>> result = await db.query('notes');
    if (result.isEmpty) {
      return <TodoCard>[];
    }
    return result.map((row) => TodoCard.fromMap(row)).toList();
  }

  static Future<int> insertNote() async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    return await db.insert('notes', {'id': null});
  }

  static Future<void> deleteNote(int id) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    await db.delete('todos', where: 'note_id = ?', whereArgs: [id]);
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Todo>> getTodos() async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    final List<Map<String, dynamic>> result = await db.query('todos');
    if (result.isEmpty) {
      return <Todo>[];
    }
    return result.map((row) => Todo.fromMap(row)).toList();
  }

  static Future<int> insertTodo(Todo todo) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    return await db.insert('todos', todo.toMap());
  }

  static Future<void> updateTodo(Todo todo) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    db.update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  static Future<void> deleteTodo(Todo todo) async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    db.delete('todos', where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> deleteAll() async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    Database db = await openDatabase(path, version: 1);
    return await db.delete('todos');
  }
}
