import 'package:sqflite/sqflite.dart';
import 'package:superhero_flutter/database/app_database.dart';
import 'package:superhero_flutter/models/hero.dart';

class HeroDao {
  insert(SuperHero hero) async {
    Database database = await AppDatabase().openDB();
    await database.insert(AppDatabase().tableName, hero.toMap());
  }

  delete(SuperHero hero) async {
    Database database = await AppDatabase().openDB();
    await database
        .delete(AppDatabase().tableName, where: "id = ?", whereArgs: [hero.id]);
  }

  Future<List> fetchAll() async {
    Database database = await AppDatabase().openDB();
    List maps = await database.query(AppDatabase().tableName);
    return maps.map((map) => FavoriteHero.fromMap(map)).toList();
  }

  Future<bool> isFavorite(SuperHero hero) async {
    Database database = await AppDatabase().openDB();
    List maps = await database
        .query(AppDatabase().tableName, where: "id = ?", whereArgs: [hero.id]);

    return maps.isNotEmpty;
  }
}
