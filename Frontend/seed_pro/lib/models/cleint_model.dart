class Client {
  final int id;
  final String name;
  final String familyName;
  final String phone;
  final String address;
  final String email;
  final int shop;

  Client({
    required this.id,
    required this.name,
    required this.familyName,
    required this.phone,
    required this.address,
    required this.email,
    required this.shop,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      familyName: json['family_name'],
      phone: json['phone'],
      address: json['address'],
      email: json['email'],
      shop: json['shop'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'family_name': familyName,
      'phone': phone,
      'address': address,
      'email': email,
      'shop': shop,
    };
  }
}
