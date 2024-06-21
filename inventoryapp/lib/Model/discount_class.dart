class Discount {
  final int? id;
  final String name;
  final double percentage;
  final String description;

  Discount({this.id, required this.name, required this.description, required this.percentage});

  // Convert a Discount object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'description': description,
      'percentage': percentage,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Extract a Discount object from a Map object
  factory Discount.fromMap(Map<String, dynamic> map) {
    return Discount(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      percentage: map['percentage'],
    );
  }
}
