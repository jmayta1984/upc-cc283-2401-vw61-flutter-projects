import 'package:sqflite/sqlite_api.dart';
import 'package:turismo_app/database/app_database.dart';
import 'package:turismo_app/models/package.dart';

class PackageDao {
  insert(Package package) async {
    Database db = await AppDatabase.openDb();
    await db.insert(AppDatabase.tableName, package.toMap());
  }

  delete(Package package) async {
    Database db = await AppDatabase.openDb();
    await db.delete(AppDatabase.tableName,
        where: "id = ?", whereArgs: [package.id]);
  }

  Future<bool> isFavorite(Package package) async {
    Database db = await AppDatabase.openDb();
    List maps = await db
        .query(AppDatabase.tableName, where: "id = ?", whereArgs: [package.id]);
    return maps.isNotEmpty;
  }

  Future<List<Package>> fetchFavorites() async {
    Database db = await AppDatabase.openDb();
    List maps = await db.query(AppDatabase.tableName);
    return maps.map((map) => Package.fromMap(map)).toList();
  }
}
