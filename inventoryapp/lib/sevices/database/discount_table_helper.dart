import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import '../../Model/discount_class.dart';

class DiscountClassDatabaseHelper {
  static final DiscountClassDatabaseHelper _instance = DiscountClassDatabaseHelper._internal();

  factory DiscountClassDatabaseHelper() {
    return _instance;
  }

  DiscountClassDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize ffi loader if needed.
    sqfliteFfiInit();

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'discounts.db');

    var databaseFactory = databaseFactoryFfi;
    return await databaseFactory.openDatabase(path, options: OpenDatabaseOptions(
      version: 1,
      onCreate: _onCreate,
    ));
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE discounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        percentage REAL
      )
    ''');
  }

  Future<int> insertDiscount(Discount discount) async {
    Database db = await database;
    return await db.insert('discounts', discount.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Discount>> getDiscounts() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('discounts');

    return List.generate(maps.length, (i) {
      return Discount.fromMap(maps[i]);
    });
  }

  Future<int> updateDiscount(Discount discount) async {
    Database db = await database;
    return await db.update(
      'discounts',
      discount.toMap(),
      where: 'id = ?',
      whereArgs: [discount.id],
    );
  }

  Future<int> deleteDiscount(int id) async {
    Database db = await database;
    return await db.delete(
      'discounts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
