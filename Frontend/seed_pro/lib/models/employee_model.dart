class Employee {
  final int id;
  final String name;
  final String familyName;
  final DateTime dateStart;
  final String email;
  final String username;
  final String password;
  final double monthlySalary;
  final int shop;

  Employee({
    required this.id,
    required this.name,
    required this.familyName,
    required this.dateStart,
    required this.email,
    required this.username,
    required this.password,
    required this.monthlySalary,
    required this.shop,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      familyName: json['family_name'],
      dateStart: DateTime.parse(json['date_start']),
      email: json['email'],
      username: json['username'],
      password: json['password'],
      monthlySalary: double.parse(json['monthly_salary']),
      shop: json['shop'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'family_name': familyName,
      'date_start': dateStart.toIso8601String(),
      'email': email,
      'username': username,
      'password': password,
      'monthly_salary': monthlySalary.toString(),
      'shop': shop,
    };
  }
}


