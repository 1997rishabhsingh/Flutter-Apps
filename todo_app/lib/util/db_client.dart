import 'package:todo_app/model/todo_item.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  final String tableName = 'todoTable';
  final String columnId = 'id';
  final String columnItemName = 'itemName';
  final String columnDateCreated = 'dateCreated';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(
        docDirectory.path, 'todo_db.db'); //e.g. home://directory/files/maindb.db

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);

    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, $columnItemName TEXT, $columnDateCreated TEXT)');
  }

  //CRUD - CREATE, READ, UPDATE, DELETE

  //Insertion

  Future<int> saveToDo(ToDoItem toDo) async {
    var dbClient = await db;

    int res = await dbClient.insert(tableName, toDo.toMap());
    return res;
  }

  Future<List> getAllItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableName ORDER BY $columnItemName ASC');

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  Future<ToDoItem> getItem(int id) async {
    var dbClient = await db;

    var result = await dbClient
        .rawQuery('SELECT * FROM $tableName WHERE $columnId = $id');
    if (result.length == 0) {
      return null;
    }

    return ToDoItem.fromMap(result.first);
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateItem(ToDoItem item) async {
    var dbClient = await db;
    return await dbClient.update(tableName, item.toMap(),
        where: '$columnId = ?', whereArgs: [item.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
