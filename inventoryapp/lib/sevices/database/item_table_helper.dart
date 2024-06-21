import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../../Model/item_class.dart';

class ItemClassDatabaseHelper {
  late Database _database;

  Future<void> initializeDatabase() async {
    final String path = await getDatabasesPath();
    final String databasePath = join(path, 'items.db');

    // Open the database or create if it doesn't exist
    _database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        // Create the items table
        return db.execute(
          'CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, category TEXT, price TEXT, margin TEXT, quantity TEXT)',
        );
      },
    );
  }

  Future<int> insertItem(Item item) async {
    await initializeDatabase();
    return await _database.insert('items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Item>> getAllItems() async {
    await initializeDatabase();
    final List<Map<String, dynamic>> maps = await _database.query('items');
    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

  Future<int> updateItem(Item item) async {
    await initializeDatabase();
    return await _database.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> updateItemQuantity(int id, String newQuantity) async {
    await initializeDatabase();
    return await _database.update(
      'items',
      {'quantity': newQuantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteItem(int id) async {
    await initializeDatabase();
    return await _database.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Item?> getItemByNameAndCategory(String name, String category) async {
    await initializeDatabase();
    final List<Map<String, dynamic>> maps = await _database.query(
      'items',
      where: 'name = ? AND category = ?',
      whereArgs: [name, category],
    );

    if (maps.isNotEmpty) {
      return Item.fromMap(maps.first);
    }
    return null;
  }
}