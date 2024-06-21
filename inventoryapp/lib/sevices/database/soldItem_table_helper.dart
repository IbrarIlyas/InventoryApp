import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../../Model/sold_item_class.dart';

class SoldItemClassDatabaseHelper {
  late Database _database;

  Future<void> initializeDatabase() async {
    final String path = await getDatabasesPath();
    final String databasePath = join(path, 'sold_items.db');

    _database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE sold_items(id INTEGER PRIMARY KEY AUTOINCREMENT, item_id INTEGER, item_name TEXT, category TEXT, price TEXT, margin TEXT, quantity TEXT, date TEXT)',
        );
      },
    );
  }

  Future<int> insertSoldItem(SoldItem soldItem) async {
    await initializeDatabase();
    return await _database.insert('sold_items', soldItem.toMap());
  }

  Future<List<SoldItem>> getSoldItemsByDay(DateTime day) async {
    await initializeDatabase();
    final String formattedDate = "${day.year}-${day.month}-${day.day}";

    final List<Map<String, dynamic>> maps = await _database.query(
      'sold_items',
      where: 'date LIKE ?',
      whereArgs: ['%$formattedDate%'],
    );

    return List.generate(maps.length, (i) {
      return SoldItem.fromMap(maps[i]);
    });
  }

  Future<List<SoldItem>> getAllSoldItems() async {
    await initializeDatabase();
    final List<Map<String, dynamic>> maps = await _database.query('sold_items');
    return List.generate(maps.length, (i) {
      return SoldItem.fromMap(maps[i]);
    });
  }

  Future<List<SoldItem>> getSoldItemsByMonth(int month) async {
    await initializeDatabase();
    final String formattedMonth = month.toString().padLeft(2, '0');

    final List<Map<String, dynamic>> maps = await _database.query(
      'sold_items',
      where: 'strftime("%m", date) = ?',
      whereArgs: [formattedMonth],
    );

    return List.generate(maps.length, (i) {
      return SoldItem.fromMap(maps[i]);
    });
  }

  Future<List<SoldItem>> getSoldItemsByMonthAndYear(int month, int year) async {
    await initializeDatabase();
    final String formattedMonth = month.toString().padLeft(2, '0');
    final String formattedYear = year.toString();

    final List<Map<String, dynamic>> maps = await _database.query(
      'sold_items',
      where: 'strftime("%m", date) = ? AND strftime("%Y", date) = ?',
      whereArgs: [formattedMonth, formattedYear],
    );

    return List.generate(maps.length, (i) {
      return SoldItem.fromMap(maps[i]);
    });
  }
}
