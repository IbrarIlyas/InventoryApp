import 'package:flutter/material.dart';

class MyDropDown extends StatefulWidget {
  final List<String> items;
  String selectedItem;
  final double? haveElevation;
  final double? width;
  final double? height;
  final ValueChanged<String> onChanged; // Callback function

  MyDropDown({
    required this.selectedItem,
    required this.items,
    required this.onChanged,
    this.haveElevation = 0,
    this.width,
    this.height,
  });

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: widget.haveElevation ?? 0,
      child: Container(
        width: widget.width,
        height: widget.height,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: widget.selectedItem,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  widget.selectedItem = newValue;
                });
                widget.onChanged(newValue); // Notify parent widget
              }
            },
            items: widget.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}