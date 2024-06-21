class Item {
  int? id;
  final String name;
  final String category;
  final String price;
  final String margin;
  String quantity;

  Item({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.margin,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'margin': margin,
      'quantity': quantity,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      price: map['price'],
      margin: map['margin'],
      quantity: map['quantity'],
    );
  }
}