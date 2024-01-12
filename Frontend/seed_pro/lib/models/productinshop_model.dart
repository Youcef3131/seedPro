class ProductInShop {
  final int id;
  final int quantity;
  final int shop;
  final int product;

  ProductInShop({
    required this.id,
    required this.quantity,
    required this.shop,
    required this.product,
  });

  factory ProductInShop.fromJson(Map<String, dynamic> json) {
    return ProductInShop(
      id: json['id'],
      quantity: json['quantity'],
      shop: json['shop'],
      product: json['product'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'shop': shop,
      'product': product,
    };
  }
}



