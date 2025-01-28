import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'weight_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'weights.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE weights(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            weight REAL,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertWeight(WeightEntry entry) async {
    final db = await database;
    return await db.insert('weights', entry.toMap());
  }

  Future<List<WeightEntry>> getWeights() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('weights');
    return List.generate(maps.length, (i) => WeightEntry.fromMap(maps[i]));
  }

  Future<void> deleteWeight(int id) async {
    final db = await database;
    await db.delete('weights', where: 'id = ?', whereArgs: [id]);
  }
}