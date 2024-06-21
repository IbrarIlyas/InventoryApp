import 'package:flutter/material.dart';
import '../../Model/discount_class.dart';

enum DiscountCardType {
  Add,
  Display,
}

class DiscountCardWidget extends StatelessWidget {
  final Discount? discount; // Optional discount for display mode
  final VoidCallback onAddPressed;
  final VoidCallback onDeletePressed;

  final DiscountCardType cardType;

  DiscountCardWidget({
    Key? key,
    this.discount,
    required this.onAddPressed,
    required this.onDeletePressed,
  }) : cardType = discount == null ? DiscountCardType.Add : DiscountCardType.Display, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: cardType == DiscountCardType.Add ? onAddPressed : null,
        child: SizedBox(
          width: 100,
          height: 100,
          child: cardType == DiscountCardType.Add
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 50, color: Colors.grey),
              Text(
                'Add Discount',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  discount!.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  discount!.description,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDeletePressed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
