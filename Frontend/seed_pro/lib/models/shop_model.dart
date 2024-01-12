
class Shop {
  final int id;
  final String name;
  final String address;
  final bool isMaster;

  Shop({
    required this.id,
    required this.name,
    required this.address,
    required this.isMaster,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      isMaster: json['is_master'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'is_master': isMaster,
    };
  }
}


