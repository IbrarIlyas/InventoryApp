import 'package:flutter/material.dart';
import '../../../Model/item_class.dart';

class ItemList extends StatelessWidget {
  final List<Item> filteredItems;
  final Function(Item) onItemTap;
  final Function(String) showErrorDialog;

  ItemList({
    required this.filteredItems,
    required this.onItemTap,
    required this.showErrorDialog,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return ListTile(
          title: Text(item.name),
          subtitle: Text("Price: €${item.price} - Category: ${item.category}"),
          trailing: Text("Quantity: ${item.quantity}"),
          onTap: () {
            if (item.quantity == '0') {
              showErrorDialog('This item is out of stock or quantity is invalid.');
            } else if (item.price.isEmpty || item.name.isEmpty) {
              showErrorDialog('Item data is invalid. Item details like name or price is missing.');
            } else {
              onItemTap(item);
            }
          },
        );
      },
    );
  }
}
