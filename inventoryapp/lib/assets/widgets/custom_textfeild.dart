import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for TextInputFormatter
import '../../Utils/constants.dart'; // Ensure this is the correct path

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool showPercentage;
  final bool isNumber;

  CustomTextField({
    required this.labelText,
    required this.controller,
    this.errorText,
    this.keyboardType,
    this.showPercentage = false,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          suffix: showPercentage ? Text('%', style: TextStyle(fontSize: 16)) : null,
          labelText: labelText,
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
        inputFormatters: isNumber
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : <TextInputFormatter>[],
      ),
    );
  }
}
