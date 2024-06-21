import 'package:flutter/material.dart';
import 'package:inventoryapp/Utils/constants.dart';
import '../../../../Model/employee_class.dart';
import '../../../sevices/database/employee_table_helper.dart';
import 'employee_access_right_filter.dart';

class EmployeeAccessRightsPage extends StatefulWidget {
  @override
  _EmployeeAccessRightsPageState createState() => _EmployeeAccessRightsPageState();
}

class _EmployeeAccessRightsPageState extends State<EmployeeAccessRightsPage> {
  final List<String> employeeRoles = ['Owner', 'Manager', 'Cashier'];
  final List<String> accessList = ['Full', 'Limited', 'Basic']; // Access for each role
  late List<bool> isChecked;
  late List<int> employeeCounts; // Count of each role
  late EmployeeClassDatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = EmployeeClassDatabaseHelper();
    isChecked = List<bool>.filled(employeeRoles.length, false);
    employeeCounts = List<int>.filled(employeeRoles.length, 0);
    _loadEmployeeData();
  }

  void _loadEmployeeData() async {
    List<Employee> employees = await _databaseHelper.getAllEmployees();
    for (int i = 0; i < employeeRoles.length; i++) {
      employeeCounts[i] = employees.where((employee) => employee.role == employeeRoles[i]).length;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: SizedBox(
          width: 600,
          child: Column(
            children: [
              const Text(
                'Employees Access Rights',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 70),
              Expanded(
                child: ListView.builder(
                  itemCount: employeeRoles.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        _buildEmployeeTile(index),
                        const Divider(color: Colors.grey),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeTile(int index) {
    String role = employeeRoles[index];
    String access = accessList[index]; // Access for current role

    IconData iconData;
    Color iconColor;
    switch (index) {
      case 0:
        iconData = Icons.person;
        iconColor = Colors.blue;
        break;
      case 1:
        iconData = Icons.supervisor_account;
        iconColor = Colors.green;
        break;
      case 2:
        iconData = Icons.person_outline;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.person;
        iconColor = Colors.blue;
    }

    return ListTile(
      leading: Checkbox(
        value: isChecked[index],
        onChanged: (value) {
          setState(() {
            isChecked[index] = value!;
          });
        },
      ),
      title: Row(
        children: [
          Icon(iconData, color: iconColor, size: 36),
          const SizedBox(width: 10),
          Text(
            role,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 100),
          Text(
            access, // Access text
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      trailing: Text(
        'Count: ${employeeCounts[index]}',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>EmployeeAccessRightsFilterPage(role: employeeRoles[index])));
      },
    );
  }
}