import 'package:flutter/material.dart';
import 'package:inventoryapp/Utils/constants.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:inventoryapp/Model/item_class.dart';
import 'package:inventoryapp/sevices/database/item_table_helper.dart';
import 'package:inventoryapp/Model/Refunded_Items.dart';
import '../../sevices/database/refunded_table_helper.dart';

class RefundItemPage extends StatefulWidget {
  @override
  _RefundItemPageState createState() => _RefundItemPageState();
}

class _RefundItemPageState extends State<RefundItemPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  String? nameError;
  String? categoryError;
  String? quantityError;
  bool isLoading = false;

  final ItemClassDatabaseHelper _dbHelper = ItemClassDatabaseHelper();
  final RefundedItemClassDatabaseHelper _refundedItemDBHelper = RefundedItemClassDatabaseHelper();

  void validateFields() {
    setState(() {
      nameError = nameController.text.isEmpty ? 'Field cannot be empty' : null;
      categoryError = categoryController.text.isEmpty ? 'Field cannot be empty' : null;
      quantityError = quantityController.text.isEmpty || int.tryParse(quantityController.text) == null ? 'Invalid input' : null;
    });
  }

  void clearFields() {
    nameController.clear();
    categoryController.clear();
    quantityController.clear();
  }

  Future<void> refundItem() async {
    validateFields();
    if (nameError == null && categoryError == null && quantityError == null) {
      setState(() {
        isLoading = true;
      });

      try {
        Item? existingItem = await _dbHelper.getItemByNameAndCategory(
          nameController.text,
          categoryController.text,
        );

        if (existingItem != null) {
          int newQuantity = int.parse(existingItem.quantity) + int.parse(quantityController.text);
          await _dbHelper.updateItemQuantity(existingItem.id!, newQuantity.toString());

          // Add refunded item to the database
          RefundedItem refundedItem = RefundedItem(
            item: existingItem,
            date: DateTime.now(),
          );

          await _refundedItemDBHelper.insertRefundedItem(refundedItem);

          clearFields();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.green[50],
                title: const Text('Item Quantity Updated Successfully'),
                shape: const RoundedRectangleBorder(),
                icon: const Icon(Icons.check, size: 20),
                iconColor: Colors.green,
              );
            },
          );
        } else {
          // Item does not exist
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.red[50],
                title: const Text('No Such Item Exists'),
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
              title: const Text('Error Updating Item'),
              content: Text(errorMessage),
              shape: const RoundedRectangleBorder(),
              icon: const Icon(Icons.error, size: 20),
              iconColor: Colors.red,
            );
          },
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: SizedBox(
          width: 700,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextField(nameController, 'Name', nameError),
              buildTextField(categoryController, 'Category', categoryError),
              buildTextField(quantityController, 'Quantity', quantityError, keyboardType: TextInputType.number),
              ElevatedButton(
                onPressed: isLoading ? null : refundItem,
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text('Refund'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTextField(TextEditingController controller, String label, String? errorText, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 16,
            color: primaryColor,
          ),
          errorText: errorText,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: errorText != null ? Colors.red : Colors.grey),
          ),
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
