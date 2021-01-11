import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqlite_test_flutter_app/MorePracticalDBClient/DBObjectProtocol.dart';

import 'Cat.dart';

// DBで取り扱いたいオブジェクトの種類
enum DBObjectsStrategy {
  cat
}

// extensionを追加することで、enumに変数や関数を追加できる
extension DBObjectsStrategyExtension on DBObjectsStrategy {

  // 各オブジェクトに対応するテーブル名を定義
  String get tableName {
    switch (this) {
      case DBObjectsStrategy.cat:
        return 'cat';
    }
  }

  // データベースから取り出したList<Map<String, dynamic>>型を各オブジェクトに変換
  List<DBObjectProtocol> getObject(List<Map<String, dynamic>> res) {
    switch (this) {
      case DBObjectsStrategy.cat:
        List<Cat> list =
        res.isNotEmpty ? res.map((c) => Cat.fromMap(c)).toList() : [];
        return list;;
    }
  }
}

class DBClient {
  static Database _database;

  static Future<Database> get database async {
    if (_database != null)
      return _database;

    // DBがなかったら作る(初回のみ)
    _database = await initDB();
    return _database;
  }

  static Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    // DB作成時にテーブル作成も行う
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  // テーブルを作成する
  static Future<void> _createTable(Database db, int version) async {
    return db.execute(
      "CREATE TABLE ${DBObjectsStrategy.cat.tableName}(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
    );
  }

  static add(DBObjectProtocol obj) async {
    final db = await database;
    var res = await db.insert(obj.strategy.tableName, obj.toMap());
    return res;
  }

  static query(DBObjectsStrategy strategy) async {
    final db = await database;
    var res = await db.query(strategy.tableName);
    List<dynamic> list = strategy.getObject(res);
    return list;
  }

  static update(DBObjectProtocol obj) async {
    final db = await database;
    var res = db.update(
      obj.strategy.tableName,
      obj.toMap(),
      where: "id = ?",
      whereArgs: [obj.id]
    );
    return res;
  }

  static delete(int id, DBObjectsStrategy strategy) async {
    final db = await database;
    var res = db.delete(
      strategy.tableName,
        where: "id = ?",
        whereArgs: [id]
    );
  }
}