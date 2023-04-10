import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql
        .getDatabasesPath(); //create database in the folder reserve for app and gives it a name 'dbPath'
    return sql.openDatabase(
      path.join(dbPath,
          'places.db'), //open if present, else create new path like dbPath/places.db
      onCreate: (db, version) {
        //execute on create on our database named db, and version may be changed when database changes
        return db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
    //firstly opening the datase with run execute program to create table, now this insert, open created db and insert in that table
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table); //retuns the table
  }
  
}
