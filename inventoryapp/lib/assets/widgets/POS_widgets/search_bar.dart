import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  CustomSearchBar({required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 200,
      child: SearchBar(
        hintText: hintText,
        leading: const Icon(Icons.search),
        controller: controller,
      ),
    );
  }
}
