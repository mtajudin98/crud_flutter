import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  static const String QUERY_TBL_CUSTOMER = """ 
    CREATE TABLE customer(
      id INTEGER PRIMARY KEY,
      nama TEXT,
      gender TEXT,
      tgl_lahir TEXT
    )
    """;

  static Future<Database?> db() async {
    return _db ??= (await DBHelper().konekDB());
  }

  Future<Database> konekDB() async {
    return await openDatabase('dbku.db', version: 1, onCreate: (db, version) {
      db.execute(QUERY_TBL_CUSTOMER);
    });
  }
}
