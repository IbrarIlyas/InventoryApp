import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for TextInputFormatter
import 'package:inventoryapp/Utils/constants.dart';
import '../../../Model/discount_class.dart';
import '../../../assets/widgets/custom_textfeild.dart';
import '../../../sevices/database/discount_table_helper.dart';

class AddDiscountPage extends StatefulWidget {
  @override
  _AddDiscountPageState createState() => _AddDiscountPageState();
}

class _AddDiscountPageState extends State<AddDiscountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _percentageController = TextEditingController();

  String? _nameError;
  String? _descriptionError;
  String? _percentageError;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _percentageController.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _nameError = _nameController.text.isEmpty ? 'Please enter a name' : null;
      _descriptionError = _descriptionController.text.isEmpty ? 'Please enter a description' : null;
      if (_percentageController.text.isEmpty) {
        _percentageError = 'Please enter a percentage';
      } else if (double.tryParse(_percentageController.text) == null) {
        _percentageError = 'Please enter a valid number';
      } else {
        _percentageError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Discount'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 200,right: 200,top: 100),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(labelText: 'Name', controller: _nameController, errorText: _nameError,),
                CustomTextField(labelText: 'Description', controller: _descriptionController, errorText: _descriptionError,),
                CustomTextField(labelText: 'Percentage', controller: _percentageController, errorText: _percentageError, keyboardType: TextInputType.number, showPercentage: true, isNumber: true,),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    _validateFields();
                    if (_nameError == null && _descriptionError == null && _percentageError == null) {
                      final discount = Discount(
                        name: _nameController.text,
                        description: _descriptionController.text,
                        percentage: double.parse(_percentageController.text),
                      );
                      await DiscountClassDatabaseHelper().insertDiscount(discount);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Add Discount'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
