import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await init();
    return _database!;
  }

  static Future<Database> init() async {
    String path = join(await getDatabasesPath(), 'mondoauto.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createTable,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS veicoli');
        await db.execute('DROP TABLE IF EXISTS marche');
        await _createTable(db, newVersion);
      },
    );
  }

  static Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE veicoli (
        id TEXT PRIMARY KEY,
        marca TEXT NOT NULL,
        modello TEXT NOT NULL,
        anno INTEGER NOT NULL,
        prezzo REAL NOT NULL,
        km INTEGER NOT NULL,
        alimentazione TEXT NOT NULL,
        colore TEXT NOT NULL,
        cambio TEXT NOT NULL,
        cv INTEGER NOT NULL,
        disponibile INTEGER NOT NULL,
        fotoUrl TEXT,
        urlSubito TEXT
      );
    ''');
    return await db.execute('''
      CREATE TABLE marche (
        id INTEGER PRIMARY KEY,
        nome TEXT NOT NULL,
        nazione TEXT NOT NULL
      );
    ''');
  }

  static Future<List<Veicolo>> getVeicoli() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('veicoli');
    if (result.isEmpty) return <Veicolo>[];
    return result.map((row) => Veicolo.fromMap(row)).toList();
  }

  static Future<int> insertVeicolo(Veicolo veicolo) async {
    final db = await database;
    return await db.insert('veicoli', veicolo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateVeicolo(Veicolo veicolo) async {
    final db = await database;
    await db.update(
      'veicoli',
      veicolo.toMap(),
      where: 'id = ?',
      whereArgs: [veicolo.id],
    );
  }

  static Future<void> deleteVeicolo(Veicolo veicolo) async {
    final db = await database;
    await db.delete(
      'veicoli',
      where: 'id = ?',
      whereArgs: [veicolo.id],
    );
  }

  static Future<List<Marca>> getMarche() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('marche');
    if (result.isEmpty) return <Marca>[];
    return result.map((row) => Marca.fromMap(row)).toList();
  }

  static Future<int> insertMarca(Marca marca) async {
    final db = await database;
    return await db.insert('marche', marca.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteMarca(Marca marca) async {
    final db = await database;
    await db.delete(
      'marche',
      where: 'id = ?',
      whereArgs: [marca.id],
    );
  }
}