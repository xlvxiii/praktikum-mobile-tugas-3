import 'package:sqflite/sqflite.dart';

class DbInstance {

  final String table = 'tasks';
  final String id = 'id';
  final String task = 'task';
  final String isDone = 'is_done';

  static Future<void> createTable(Database database) async {
    await database.execute(
        'create table tasks (id integer primary key, task text, is_done integer default 0)');
  }

  // init
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

  // select all
  static Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await _database();
    return db.rawQuery('select * from tasks');
  }

  // select done tasks
  static Future<List<Map<String, dynamic>>> getUndoneTasks() async {
    final db = await _database();
    return db.query('tasks', where: 'is_done = ?', whereArgs: [0]);
  }

  // select done tasks
  static Future<List<Map<String, dynamic>>> getDoneTasks() async {
    final db = await _database();
    return db.query('tasks', where: 'is_done = ?', whereArgs: [1]);
  }

  // delete
  static Future<void> deleteTask(int id) async {
    final db = await _database();
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // update undone task
  static Future<int> updateTask(id) async {
    final db = await _database();

    final data = {'is_done': 1};
    return await db.update('tasks', data, where: 'id = ?', whereArgs: [id]);
  }

  // update undo complete task
  static Future<int> undoTask(id) async {
    final db = await _database();

    final data = {'is_done': 0};
    return await db.update('tasks', data, where: 'id = ?', whereArgs: [id]);
  }

  // get task by id
  static Future<List<Map<String, dynamic>>> getTask(int id) async {
    final db = await _database();
    return db.query('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
