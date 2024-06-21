import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_picker/country_picker.dart';
import '../../../../Model/customer_class.dart';
import '../../../../Utils/constants.dart';
import '../../../sevices/database/customer_table_helper.dart';

class AddCustomer extends StatefulWidget {
  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _customerCodeController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final CustomerClassDatabaseHelper _dbHelper = CustomerClassDatabaseHelper(); // Add database helper

  Country? _selectedCountry; // Track selected country

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _regionController.dispose();
    _postalCodeController.dispose();
    _customerCodeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showWorldWide: true,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Customer'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildNameField(),
              const SizedBox(height: 16.0),
              _buildOptionalTextField(_emailController, 'Email', Icons.email),
              const SizedBox(height: 16.0),
              _buildOptionalTextField(_phoneController, 'Phone', Icons.phone, inputTypenumber: true),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _buildOptionalTextField(_cityController, 'City', null),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: _buildOptionalTextField(_regionController, 'Region', null),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _buildOptionalTextField(_postalCodeController, 'Postal code', null, inputTypenumber: true),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectCountry,
                      child: Text(_selectedCountry?.name ?? 'Select Country'),
                    ),
                  ),
                ],
              ),
              _buildOptionalTextField(_customerCodeController, 'Customer code', Icons.qr_code),
              _buildOptionalTextField(_noteController, 'Note', Icons.message),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Cancel and return to the previous screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        Customer customer = Customer(
                          name: _nameController.text,
                          email: _emailController.text,
                          phone: _phoneController.text,
                          city: _cityController.text,
                          region: _regionController.text,
                          postalCode: _postalCodeController.text,
                          country: _selectedCountry?.name, // Add selected country here
                          customerCode: _customerCodeController.text,
                          note: _noteController.text,
                        );
                        try {
                          int result = await _dbHelper.insertCustomer(customer);
                          if (result != -1) {
                            print('Customer added successfully with ID: $result');
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.green[50],
                                  title: const Text('Customer Added successfully'),
                                  shape: const RoundedRectangleBorder(),
                                  icon: const Icon(Icons.check, size: 20),
                                  iconColor: Colors.green,
                                );
                              },
                            ).then((_) {
                              Navigator.pop(context);
                            });
                          } else {
                            print('Failed to add customer to the database');
                          }
                        } catch (e) {
                          print('Error adding customer: $e');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Name',
        labelStyle: TextStyle(color: primaryColor),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Name is required';
        }
        return null;
      },
    );
  }

  Widget _buildOptionalTextField(TextEditingController controller, String label, IconData? icon, {bool inputTypenumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: primaryColor),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          prefixIcon: icon != null ? Icon(icon, color: primaryColor) : null,
        ),
        keyboardType: inputTypenumber ? TextInputType.number : TextInputType.text,
        inputFormatters: inputTypenumber ? [FilteringTextInputFormatter.digitsOnly] : [],
      ),
    );
  }
}
