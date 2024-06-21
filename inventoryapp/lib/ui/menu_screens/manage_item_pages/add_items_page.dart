
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Utils/constants.dart';
import 'add_items.dart';
import 'import_items.dart';

class AddItem extends StatefulWidget {

  bool showAppBar;

  AddItem({required this.showAppBar});

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar?AppBar(backgroundColor: primaryColor,foregroundColor: Colors.white,):null,
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            height: 400,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined,
                        size: 100, color: primaryColor),
                    SizedBox(height: 20),
                    Text(
                      'Add Your Items to Inventory',
                      style: GoogleFonts.aBeeZee(
                          fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder:(BuildContext context)=>AddItemPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            shape: RoundedRectangleBorder(),
                          ),
                          child: Text(
                            "Add Item",
                            style: GoogleFonts.aBeeZee(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder:(BuildContext context)=>ImportItemsPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor, // Change color for the second button
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            shape: RoundedRectangleBorder(),
                          ),
                          child: Text(
                            "Import Items",
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
        ),
      ),
    );
  }
}
