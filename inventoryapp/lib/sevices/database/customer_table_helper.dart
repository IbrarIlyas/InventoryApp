import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../../Model/customer_class.dart';

class CustomerClassDatabaseHelper {
  static final CustomerClassDatabaseHelper _instance = CustomerClassDatabaseHelper._internal();
  factory CustomerClassDatabaseHelper() => _instance;
  static Database? _database;

  CustomerClassDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'customer.db');
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _onCreate,
      ),
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        phone TEXT,
        city TEXT,
        region TEXT,
        postalCode TEXT,
        country TEXT,
        customerCode TEXT,
        note TEXT
      )
    ''');
  }

  Future<int> insertCustomer(Customer customer) async {
    Database db = await database;
    var customerMap = customer.toMap();
    if (customerMap['id'] == null) {
      customerMap.remove('id');
    }
    return await db.insert('customers', customerMap);
  }

  Future<List<Customer>> getCustomers() async {
    Database db = await database;
    var customers = await db.query('customers', orderBy: 'id');
    List<Customer> customerList = customers.isNotEmpty ? customers.map((c) => Customer.fromMap(c)).toList() : [];
    return customerList;
  }

  Future<int> deleteCustomer(int id) async {
    Database db = await database;
    return await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateCustomer(Customer customer) async {
    Database db = await database;
    return await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }
}
