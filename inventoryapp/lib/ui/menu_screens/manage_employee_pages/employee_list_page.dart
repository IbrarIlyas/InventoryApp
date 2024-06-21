import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inventoryapp/Utils/constants.dart';
import '../../../../Model/employee_class.dart';
import '../../../sevices/database/employee_table_helper.dart';
import 'add_employee_page.dart';

class EmployeeList extends StatefulWidget {
  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  late List<Employee> _employees;
  late Timer _timer;
  late EmployeeClassDatabaseHelper _databaseHelper;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _databaseHelper = EmployeeClassDatabaseHelper();
    _startTimer();
    _loadEmployees();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _loadEmployees());
  }

  void _loadEmployees() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    _employees = await _databaseHelper.getAllEmployees();
    setState(() {
      _isLoading = false; // Hide loading indicator
    });
  }

  void _navigateToAddEmployeePage() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => AddEmployeePage()));
    _loadEmployees();
  }

  Future<void> _deleteEmployee(int id) async {
    await _databaseHelper.deleteEmployee(id);
    _loadEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator()) // Show loading indicator
                  : Container(
                width: 900,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Name',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'City',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Contact',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Email',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Password',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Delete',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                    rows: _employees.map((employee) {
                      return DataRow(
                        cells: [
                          DataCell(Text(employee.name)),
                          DataCell(Text(employee.city)),
                          DataCell(Text(employee.contact)),
                          DataCell(Text(employee.email)),
                          DataCell(Text(employee.password)),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteEmployee(employee.id!);
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddEmployeePage,
        backgroundColor: primaryColor,
        tooltip: 'Add Employee',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
