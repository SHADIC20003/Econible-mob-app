import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trackizer/view/login/user.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Users.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT NOT NULL, password TEXT NOT NULL);"),
        version: _version);
  }

  static Future<int> addUser(User user) async {
    final db = await _getDB();
    return await db.insert("User", user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<User>> getAllUsers() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('User');

    // Convert List<Map<String, dynamic>> to List<User>
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        username: maps[i]['username'],
        password: maps[i]['password'],
      );
    });
  }
  
  static Future<void> printAllUsers() async {
    final users = await getAllUsers();
    users.forEach((user) {
      print('User ID: ${user.id}, Username: ${user.username}, Password: ${user.password}');
    });
  }
}
