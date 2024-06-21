import 'package:flutter/material.dart';
import 'package:inventoryapp/Model/employee_class.dart';
import 'package:inventoryapp/Utils/constants.dart';
import 'package:inventoryapp/assets/widgets/custom_textfeild.dart';
import '../../../assets/widgets/drop_down.dart';
import '../../../sevices/database/employee_table_helper.dart';

class AddEmployeePage extends StatefulWidget {
  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedRole;
  String? nameError;
  String? cityError;
  String? contactError;
  String? positionError;
  String? emailError;
  String? passwordError;

  final EmployeeClassDatabaseHelper databaseHelper = EmployeeClassDatabaseHelper();

  void validateFields() {
    setState(() {
      nameError = nameController.text.isEmpty ? 'Field cannot be empty' : null;
      cityError = cityController.text.isEmpty ? 'Field cannot be empty' : null;
      contactError = contactController.text.isEmpty ? 'Field cannot be empty' : null;
      positionError = selectedRole == null ? 'Field cannot be empty' : null;
      emailError = emailController.text.isEmpty ? 'Field cannot be empty' : null;
      passwordError = passwordController.text.isEmpty ? 'Field cannot be empty' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Add Employee'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: SizedBox(
          width: 700,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: nameController,
                errorText: nameError,
                labelText: 'Name',
              ),
              CustomTextField(
                controller: cityController,
                errorText:  cityError,
                labelText: 'City',
              ),
              CustomTextField(
                controller: contactController,
                errorText: contactError,
                labelText: 'Contact',
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: ['Cashier', 'Manager'].map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value;
                      positionError = null;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Role',
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                    ),
                    errorText: positionError,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: positionError != null ? Colors.red : Colors.grey),
                    ),
                  ),
                ),
              ),
              CustomTextField(
                controller: emailController,
                errorText: emailError,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                controller: passwordController,
                labelText: 'Password',
                errorText: passwordError,
                keyboardType: TextInputType.visiblePassword,
              ),
              ElevatedButton(
                onPressed: () async {
                  validateFields();
                  if (nameError == null && cityError == null && contactError == null && positionError == null && emailError == null && passwordError == null) {
                    String access = selectedRole == 'Manager' ? 'full' : 'partial';
                    await databaseHelper.insertEmployee(Employee(
                      name: nameController.text,
                      city: cityController.text,
                      contact: contactController.text,
                      role: selectedRole!,
                      access: access,
                      email: emailController.text,
                      password: passwordController.text,
                    ));
                    nameController.clear();
                    cityController.clear();
                    contactController.clear();
                    setState(() {
                      selectedRole = null;
                      emailController.clear();
                      passwordController.clear();
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.green[50],
                          title: const Text('Employee Added Successfully'),
                          shape: const RoundedRectangleBorder(),
                          icon: const Icon(
                            Icons.check,
                            size: 20,
                          ),
                          iconColor: Colors.green,
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add Employee'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
