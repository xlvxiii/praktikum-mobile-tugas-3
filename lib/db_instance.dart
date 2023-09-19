import 'package:sqflite/sqflite.dart';

class DbInstance {
  final String _dbName = 'to_do.db';
  final int _dbVersion = 1;

  final String table = 'tasks';
  final String id = 'id';
  final String task = 'task';
  final String isDone = 'is_done';

  static Future<void> createTable(Database database) async {
    await database.execute(
        'create table tasks (id integer primary key, task text, is_done integer default 0)');
  }

  static Future<Database> _database() async {
    return openDatabase('to_do_list_app.db', version: 1,
        onCreate: (Database database, int version) async {
      await createTable(database);
    });
  }

  // create
  static Future<int> insertTask(String task) async {
    final db = await _database();
    final data = {'task': task};
    final id = await db.insert('tasks', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  // select
  static Future<List<Map<String, dynamic>>> getUndoneTasks() async {
    final db = await _database();
    return db.query('tasks', where: 'is_done = ?', whereArgs: [0]);
  }

  static Future<void> deleteTask(int id) async {
    final db = await _database();
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
