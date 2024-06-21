import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static final SqlDb _instance = SqlDb._internal();
  factory SqlDb() => _instance;
  static Database? _database;

  SqlDb._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'trackizer.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE reminders(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, date TEXT, amount TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertReminder(Map<String, String> reminder) async {
    final db = await database;
    await db.insert('reminders', reminder);
  }

  Future<List<Map<String, dynamic>>> getReminders() async {
    final db = await database;
    return await db.query('reminders');
  }

  Future<void> deleteReminder(int id) async {
    final db = await database;
    await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }
}
