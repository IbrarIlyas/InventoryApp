import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../Model/employee_class.dart';

class EmployeeClassDatabaseHelper {
  late Database _database;

  // Singleton pattern to ensure only one instance of the database helper exists
  static final EmployeeClassDatabaseHelper _instance =
  EmployeeClassDatabaseHelper._internal();

  factory EmployeeClassDatabaseHelper() => _instance;

  EmployeeClassDatabaseHelper._internal();

  // Method to initialize the database
  Future<void> initializeDatabase() async {
    final String path = await getDatabasesPath();
    final String databasePath = join(path, 'employees.db');

    // Open the database or create if it doesn't exist
    _database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  // Method to create the database tables
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employees(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        password TEXT,
        city TEXT,
        contact TEXT,
        role TEXT,
        access TEXT
      )
    ''');
  }

  // Method to insert an employee into the database
  Future<int> insertEmployee(Employee employee) async {
    await initializeDatabase();
    return await _database.insert('employees', employee.toMap());
  }

  // Method to retrieve all employees from the database
  Future<List<Employee>> getAllEmployees() async {
    await initializeDatabase();
    final List<Map<String, dynamic>> maps = await _database.query('employees');
    return List.generate(maps.length, (i) {
      return Employee.fromMap(maps[i]);
    });
  }

  // Method to retrieve employees by role from the database
  Future<List<Employee>> getEmployeesByRole(String role) async {
    await initializeDatabase();
    final List<Map<String, dynamic>> maps = await _database.query(
      'employees',
      where: 'role = ?',
      whereArgs: [role],
    );
    return List.generate(maps.length, (i) {
      return Employee.fromMap(maps[i]);
    });
  }

  // Method to update an employee in the database
  Future<int> updateEmployee(Employee employee) async {
    await initializeDatabase();
    return await _database.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  // Method to delete an employee from the database
  Future<int> deleteEmployee(int id) async {
    await initializeDatabase();
    return await _database.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
