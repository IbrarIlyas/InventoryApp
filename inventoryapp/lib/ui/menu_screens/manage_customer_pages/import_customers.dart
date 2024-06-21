import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import '../../../../Model/customer_class.dart';
import '../../../../Utils/constants.dart';
import '../../../sevices/database/customer_table_helper.dart';

class ImportCustomer extends StatefulWidget {
  @override
  _ImportCustomerState createState() => _ImportCustomerState();
}

class _ImportCustomerState extends State<ImportCustomer> {
  final CustomerClassDatabaseHelper _dbHelper = CustomerClassDatabaseHelper();

  Future<void> pickAndLoadCustomerExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table];
        if (sheet == null) continue;

        for (var row in sheet.rows.skip(1)) {
          Customer newCustomer = Customer(
            name: row[0]?.value?.toString(),
            email: row[1]?.value?.toString(),
            phone: row[2]?.value?.toString(),
            city: row[3]?.value?.toString(),
            region: row[4]?.value?.toString(),
            postalCode: row[5]?.value?.toString(),
            country: row[6]?.value?.toString(),
            customerCode: row[7]?.value?.toString(),
            note: row[8]?.value?.toString(),
          );

          try {
            int customerId = await _dbHelper.insertCustomer(newCustomer); // Insert customer into the database
            print('Customer added with ID: $customerId');
          } catch (e) {
            print('Error adding customer: $e');
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Customers imported successfully'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Import Customer Data',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: pickAndLoadCustomerExcel,
          child: const Text('Import Customers'),
        ),
      ),
    );
  }
}
