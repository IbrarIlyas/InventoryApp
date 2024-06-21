import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            'Checkout',
            style: GoogleFonts.acme(fontSize: 30, letterSpacing: 3),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shipping Information",
                    style: GoogleFonts.acme(fontSize: 20, letterSpacing: 2),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Name",
                    style: GoogleFonts.aBeeZee(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Chak 497/EB, Burewala, Vehari",
                    style: GoogleFonts.aBeeZee(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Courier Service",
                    style: GoogleFonts.acme(fontSize: 20, letterSpacing: 2),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "DHL Express",
                    style: GoogleFonts.aBeeZee(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Will be delivered in 3 days",
                    style: GoogleFonts.aBeeZee(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Payment Method",
                  style: GoogleFonts.aBeeZee(fontSize: 10),
                ),
                Text(
                  "Add new card",
                  style: GoogleFonts.aBeeZee(fontSize: 10, color: Colors.blueAccent),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Center(
              child: Text(
                'Payment Methods will be displayed here',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(100, 50),
                shape: RoundedRectangleBorder(),
              ),
              onPressed: () {},
              child: const Text("Check Out"),
            ),
          ),
        ],
      ),
    );
  }
}
