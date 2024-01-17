class Product {
  final int id;
  final String reference;
  final String description;
  final double buyingPrice;
  final double sellingPrice;
  final int category;

  Product({
    required this.id,
    required this.reference,
    required this.description,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      reference: json['reference'],
      description: json['description'],
      buyingPrice: json['buyingPrice'] != null
          ? double.tryParse(json['buyingPrice'].toString()) ?? 0.0
          : 0.0,
      sellingPrice: json['sellingPrice'] != null
          ? double.tryParse(json['sellingPrice'].toString()) ?? 0.0
          : 0.0,
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'description': description,
      'buying_price': buyingPrice,
      'saleing_price': sellingPrice, // Corrected field name
      'category': category,
    };
  }
}
