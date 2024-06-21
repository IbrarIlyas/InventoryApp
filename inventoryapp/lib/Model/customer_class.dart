class Customer {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? city;
  String? region;
  String? postalCode;
  String? country;
  String? customerCode;
  String? note;

  Customer({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.city,
    this.region,
    this.postalCode,
    this.country,
    this.customerCode,
    this.note,
  });

  Customer copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? city,
    String? region,
    String? postalCode,
    String? country,
    String? customerCode,
    String? note,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      region: region ?? this.region,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      customerCode: customerCode ?? this.customerCode,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
      'region': region,
      'postalCode': postalCode,
      'country': country,
      'customerCode': customerCode,
      'note': note,
    };
    map.removeWhere((key, value) => key == 'id' && value == null);
    return map;
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      city: map['city'],
      region: map['region'],
      postalCode: map['postalCode'],
      country: map['country'],
      customerCode: map['customerCode'],
      note: map['note'],
    );
  }
}
