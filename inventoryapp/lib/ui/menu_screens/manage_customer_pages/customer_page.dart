import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Model/customer_class.dart';
import '../../../../Utils/constants.dart';
import 'add_customer_page.dart';
import 'import_customers.dart';
import '../../../sevices/database/customer_table_helper.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  List<Customer> customers = [];
  final CustomerClassDatabaseHelper dbHelper = CustomerClassDatabaseHelper();

  @override
  void initState() {
    super.initState();
    _refreshCustomerList();
  }

  Future<void> _refreshCustomerList() async {
    List<Customer> fetchedCustomers = await dbHelper.getCustomers();
    setState(() {
      customers = fetchedCustomers;
    });
  }

  Future<void> _deleteCustomer(int id) async {
    await dbHelper.deleteCustomer(id);
    _refreshCustomerList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            height: 600,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.group_rounded,
                        size: 50, color: primaryColor),
                    Text(
                      'Customers',
                      style: GoogleFonts.aBeeZee(
                          fontSize: 20, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Manage your Customers',
                      style: GoogleFonts.aBeeZee(
                          fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final newCustomer = await Navigator.push<Customer>(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AddCustomer(),
                              ),
                            );
                            if (newCustomer != null) {
                              await dbHelper.insertCustomer(newCustomer);
                              _refreshCustomerList();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            shape: const RoundedRectangleBorder(),
                          ),
                          child: Text(
                            "Add Customers",
                            style: GoogleFonts.aBeeZee(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ImportCustomer(),
                              ),
                            );
                            _refreshCustomerList();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            shape: const RoundedRectangleBorder(),
                          ),
                          child: Text(
                            "Import Customers",
                            style: GoogleFonts.aBeeZee(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Table(
                            border: TableBorder.all(),
                            columnWidths: const {
                              0: FixedColumnWidth(100),
                              1: FixedColumnWidth(100),
                              2: FixedColumnWidth(100),
                              3: FixedColumnWidth(100),
                              4: FixedColumnWidth(100),
                              5: FixedColumnWidth(100),
                              6: FixedColumnWidth(100),
                              7: FixedColumnWidth(100),
                              8: FixedColumnWidth(100),
                              9: FixedColumnWidth(100), // Added for delete button
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                ),
                                children: [
                                  _buildHeaderCell('Name'),
                                  _buildHeaderCell('Email'),
                                  _buildHeaderCell('Phone'),
                                  _buildHeaderCell('City'),
                                  _buildHeaderCell('Region'),
                                  _buildHeaderCell('Postal Code'),
                                  _buildHeaderCell('Country'),
                                  _buildHeaderCell('Customer Code'),
                                  _buildHeaderCell('Note'),
                                  _buildHeaderCell('Delete'),
                                ],
                              ),
                              for (var customer in customers)
                                TableRow(
                                  children: [
                                    _buildCell(customer.name ?? ''),
                                    _buildCell(customer.email ?? ''),
                                    _buildCell(customer.phone ?? ''),
                                    _buildCell(customer.city ?? ''),
                                    _buildCell(customer.region ?? ''),
                                    _buildCell(customer.postalCode ?? ''),
                                    _buildCell(customer.country ?? ''),
                                    _buildCell(customer.customerCode ?? ''),
                                    _buildCell(customer.note ?? ''),
                                    _buildDeleteButton(customer.id??0),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildCell(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text),
      ),
    );
  }

  Widget _buildDeleteButton(int id) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _deleteCustomer(id);
          },
        ),
      ),
    );
  }
}
