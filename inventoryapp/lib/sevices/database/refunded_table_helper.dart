import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../../Model/Refunded_Items.dart';

class RefundedItemClassDatabaseHelper {
  late Database _database;

  Future<void> initializeDatabase() async {
    final String path = await getDatabasesPath();
    final String databasePath = join(path, 'refunded_items.db');

    _database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE refunded_items(id INTEGER PRIMARY KEY AUTOINCREMENT, item_id INTEGER, item_name TEXT, category TEXT, price TEXT, margin TEXT, quantity TEXT, date TEXT)',
        );
      },
    );
  }

  Future<int> insertRefundedItem(RefundedItem refundedItem) async {
    await initializeDatabase();
    return await _database.insert('refunded_items', refundedItem.toMap());
  }

  Future<List<RefundedItem>> getRefundedItemsByDay(DateTime day) async {
    await initializeDatabase();
    final String formattedDate = "${day.year}-${day.month}-${day.day}";

    final List<Map<String, dynamic>> maps = await _database.query(
      'refunded_items',
      where: 'date LIKE ?',
      whereArgs: ['%$formattedDate%'],
    );

    return List.generate(maps.length, (i) {
      return RefundedItem.fromMap(maps[i]);
    });
  }

  Future<List<RefundedItem>> getAllRefundedItems() async {
    await initializeDatabase();
    final List<Map<String, dynamic>> maps = await _database.query('refunded_items');
    return List.generate(maps.length, (i) {
      return RefundedItem.fromMap(maps[i]);
    });
  }

  Future<List<RefundedItem>> getRefundedItemsByMonth(int month) async {
    await initializeDatabase();
    final String formattedMonth = month.toString().padLeft(2, '0');

    final List<Map<String, dynamic>> maps = await _database.query(
      'refunded_items',
      where: 'strftime("%m", date) = ?',
      whereArgs: [formattedMonth],
    );

    return List.generate(maps.length, (i) {
      return RefundedItem.fromMap(maps[i]);
    });
  }

  Future<List<RefundedItem>> getRefundedItemsByMonthAndYear(int month, int year) async {
    await initializeDatabase();
    final String formattedMonth = month.toString().padLeft(2, '0');
    final String formattedYear = year.toString();

    final List<Map<String, dynamic>> maps = await _database.query(
      'refunded_items',
      where: 'strftime("%m", date) = ? AND strftime("%Y", date) = ?',
      whereArgs: [formattedMonth, formattedYear],
    );

    return List.generate(maps.length, (i) {
      return RefundedItem.fromMap(maps[i]);
    });
  }
}
