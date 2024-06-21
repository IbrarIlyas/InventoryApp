import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import '../../../../Model/item_class.dart';
import '../../../../Utils/constants.dart';
import '../../../sevices/database/item_table_helper.dart';

class ImportItemsPage extends StatefulWidget {
  @override
  _ImportItemsPageState createState() => _ImportItemsPageState();
}

class _ImportItemsPageState extends State<ImportItemsPage> {
  final ItemClassDatabaseHelper _dbHelper = ItemClassDatabaseHelper();

  Future<void> pickAndLoadExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      List<Item> tempList = [];

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table];
        if (sheet == null) continue;

        for (var row in sheet.rows.skip(1)) {
          Item newItem = Item(
            name: row[0]?.value?.toString() ?? '',
            category: row[1]?.value?.toString() ?? '',
            price: row[2]?.value?.toString() ?? '',
            margin: row[3]?.value?.toString() ?? '',
            quantity: row[4]?.value?.toString() ?? '',
          );
          tempList.add(newItem);
        }
      }

      for (var item in tempList) {
        await _dbHelper.insertItem(item);
      }

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data uploaded successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Import Excel Data',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('No data loaded.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickAndLoadExcel,
        child: const Icon(Icons.add),
      ),
    );
  }
}
