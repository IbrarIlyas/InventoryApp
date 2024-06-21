import 'item_class.dart';

class SoldItem {
  int? id;
  Item item;
  DateTime date;

  SoldItem({
    this.id,
    required this.item,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item_id': item.id,
      'item_name': item.name,
      'category': item.category,
      'price': item.price,
      'margin': item.margin,
      'quantity': item.quantity,
      'date': date.toIso8601String(),
    };
  }

  factory SoldItem.fromMap(Map<String, dynamic> map) {
    return SoldItem(
      id: map['id'],
      item: Item(
        id: map['item_id'],
        name: map['item_name'],
        category: map['category'],
        price: map['price'],
        margin: map['margin'],
        quantity: map['quantity'],
      ),
      date: DateTime.parse(map['date']),
    );
  }
}
