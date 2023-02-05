import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;

class DBHelper {
  static Future<Database> database() async {
    Directory? directory = await getExternalStorageDirectory();
    return await openDatabase(
      Path.join(directory!.path, "dictionary.db"),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE IF NOT EXISTS histories(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,'
            ' word TEXT,'
            ' form TEXT,'
            ' pronunciationUS TEXT,'
            ' pronunciationUK TEXT,'
            ' definition TEXT,'
            ' similar TEXT,'
            ' speciality TEXT,'
            ' isLiked TEXT)');
      },
      version: 1,
    );
  }

  static Future selectDictionaryByWord(String word) async {
    final db = await DBHelper.database();
    return await db.rawQuery(
      "SELECT * from dictionaries where word = ? ",
      [word],
    );
  }

  static Future insertRecent(Map<String, Object> data) async {
    final db = await DBHelper.database();
    return db.insert('histories', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> selectAllRecent() async {
    final db = await DBHelper.database();
    return db
        .rawQuery('SELECT * FROM histories GROUP BY word ORDER BY word DESC');
  }

  static Future<List<Map<String, dynamic>>> selectAllFavorite() async {
    final db = await DBHelper.database();
    return db.rawQuery(
        'SELECT * FROM histories WHERE isLiked = ? GROUP BY word ORDER BY word DESC',
        ['true']);
  }
}
