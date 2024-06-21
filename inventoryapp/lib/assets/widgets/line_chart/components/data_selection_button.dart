import 'package:flutter/material.dart';

class DataSelectionButton extends StatelessWidget {
  final String option;
  final bool isSelected;
  final VoidCallback onPressed;

  const DataSelectionButton({
    Key? key,
    required this.option,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.deepPurple.shade200 : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder()
          ),
          child: Text(
            option,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
