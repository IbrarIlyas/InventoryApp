import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventoryapp/Utils/constants.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../../../Model/item_class.dart';
import '../../../assets/widgets/custom_textfeild.dart';
import '../../../sevices/database/item_table_helper.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController marginController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String? nameError;
  String? categoryError;
  String? marginError;
  String? quantityError;
  String? priceError;

  final ItemClassDatabaseHelper _dbHelper = ItemClassDatabaseHelper();

  void validateFields() {
    setState(() {
      nameError = nameController.text.isEmpty ? 'Field cannot be empty' : null;
      categoryError = categoryController.text.isEmpty ? 'Field cannot be empty' : null;
      marginError = marginController.text.isEmpty ? 'Field cannot be empty' : null;
      quantityError = quantityController.text.isEmpty || int.tryParse(quantityController.text) == null ? 'Invalid input' : null;
      priceError = priceController.text.isEmpty ? 'Field cannot be empty' : null;
    });
  }

  void clearFields() {
    nameController.clear();
    categoryController.clear();
    marginController.clear();
    quantityController.clear();
    priceController.clear();
  }

  Future<void> addItem() async {
    validateFields();
    if (nameError == null && categoryError == null && marginError == null && quantityError == null && priceError == null) {
      Item newItem = Item(
        name: nameController.text,
        category: categoryController.text,
        margin: marginController.text,
        quantity: quantityController.text,
        price: priceController.text,
      );

      try {
        int result = await _dbHelper.insertItem(newItem);
        if (result > 0) {
          clearFields();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.green[50],
                title: const Text('Item Added Successfully'),
                shape: const RoundedRectangleBorder(),
                icon: const Icon(Icons.check, size: 20),
                iconColor: Colors.green,
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.red[50],
                title: const Text('Error Adding Item'),
                shape: const RoundedRectangleBorder(),
                icon: const Icon(Icons.error, size: 20),
                iconColor: Colors.red,
              );
            },
          );
        }
      } catch (e) {
        String errorMessage = 'Unknown error occurred';
        if (e is DatabaseException) {
          errorMessage = 'Database error: ${e.toString()}';
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red[50],
              title: const Text('Error Adding Item'),
              content: Text(errorMessage),
              shape: const RoundedRectangleBorder(),
              icon: const Icon(Icons.error, size: 20),
              iconColor: Colors.red,
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Add Item'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: SizedBox(
          width: 700,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(labelText: 'Name', controller: nameController, errorText: nameError,),
              CustomTextField(labelText: 'Category', controller: categoryController, errorText: categoryError,),
              CustomTextField(labelText: 'Margin', controller: marginController, errorText: marginError, showPercentage: true, isNumber: true,),
              CustomTextField(labelText: 'Quantity', controller: quantityController, errorText: quantityError, keyboardType: TextInputType.number, isNumber: true,),
              CustomTextField(labelText: 'Price', controller: priceController, errorText: priceError, keyboardType: TextInputType.number, isNumber: true,),
              ElevatedButton(
                onPressed: addItem,
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
