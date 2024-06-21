import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritePage extends StatelessWidget {
  final bool showAppBar;
  FavoritePage({this.showAppBar = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: showAppBar ? AppBar() : null,
      body: Padding(
        padding: showAppBar ? const EdgeInsets.only(top: 20, left: 20, right: 20) : const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Favorites',
                  style: GoogleFonts.acme(fontSize: 30, letterSpacing: 3),
                ),
                Text(
                  'X items', // Replace 'X' with dynamic item count
                  style: GoogleFonts.aBeeZee(
                    color: Colors.grey.shade600,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Favorite Items will be displayed here',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
