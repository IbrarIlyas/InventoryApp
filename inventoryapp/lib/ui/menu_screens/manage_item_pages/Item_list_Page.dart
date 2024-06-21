import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventoryapp/Utils/constants.dart';
import 'package:inventoryapp/Model/item_class.dart';
import 'dart:async';
import '../../../sevices/database/item_table_helper.dart';
import 'add_items.dart';

class ItemListPage extends StatefulWidget {
  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List<Item> items = [];
  final ItemClassDatabaseHelper _dbHelper = ItemClassDatabaseHelper();

  @override
  void initState() {
    super.initState();
    fetchItemsFromDatabase();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      fetchItemsFromDatabase();
    });
  }

  Future<void> fetchItemsFromDatabase() async {
    List<Item> fetchedItems = await _dbHelper.getAllItems();
    setState(() {
      items = fetchedItems;
    });
  }

  Future<void> deleteItem(int id) async {
    await _dbHelper.deleteItem(id);
    fetchItemsFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            height: 1500,
            child: items.isEmpty
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.category_outlined,
                              size: 100, color: primaryColor),
                          const SizedBox(height: 20),
                          Text(
                            "You didn't add any item to your app's inventory",
                            style: GoogleFonts.aBeeZee(
                                fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AddItemPage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  shape:
                                  const RoundedRectangleBorder(),
                                ),
                                child: Text(
                                  "Add Items",
                                  style: GoogleFonts.aBeeZee(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
                : SingleChildScrollView(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Item List',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Table(
                        border: TableBorder.all(),
                        columnWidths: const {
                          0: FixedColumnWidth(100),
                          1: FixedColumnWidth(100),
                          2: FixedColumnWidth(100),
                          3: FixedColumnWidth(100),
                          4: FixedColumnWidth(100),
                          5: FixedColumnWidth(100), // New column for delete button
                        },
                        children: [
                          const TableRow(
                            decoration: BoxDecoration(
                              color: primaryColor,
                            ),
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Category',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Price',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Margin',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Quantity',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ...items.map((item) {
                            return TableRow(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(item.name),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(item.category),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(item.price),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(item.margin),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(item.quantity.toString()),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        deleteItem(item.id!);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
