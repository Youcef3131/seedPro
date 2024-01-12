class ProductDetails {
  final int id;
  final int quantity;
  final int shop;
  final String reference;
  final String description;
  final double buyingPrice;
  final double sellingPrice;
  final int category;

  ProductDetails({
    required this.id,
    required this.quantity,
    required this.shop,
    required this.reference,
    required this.description,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.category,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json['id'],
      quantity: json['quantity'],
      shop: json['shop'],
      reference: json['reference'],
      description: json['description'],
      buyingPrice: double.parse(json['buying_price']),
      sellingPrice: double.parse(json['saleing_price']),
      category: json['category'],
    );
  }
}
