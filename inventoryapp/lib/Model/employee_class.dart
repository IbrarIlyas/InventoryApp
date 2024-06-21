class Employee {
  int? id;
  final String name;
  final String city;
  final String contact;
  final String role;
  final String access;
  final String email;
  final String password;

  Employee({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.city,
    required this.contact,
    required this.role,
    required this.access,
  });

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      city: map['city'],
      contact: map['contact'],
      role: map['role'],
      access: map['access'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'city': city,
      'contact': contact,
      'role': role,
      'access': access,
    };
  }
}