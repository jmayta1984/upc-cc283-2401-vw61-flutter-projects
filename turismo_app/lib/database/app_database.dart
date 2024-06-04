import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static int version = 1;
  static String databaseName = "turismo.db";
  static String tableName = "packages";
  static Database? _db;

  static Future<Database> openDb() async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: version,
      onCreate: (db, version) {
        String query =
            "create table $tableName (id text primary key, name text, description text, image text)";
        db.execute(query);
      },
    );
    return _db as Database;
  }
}
