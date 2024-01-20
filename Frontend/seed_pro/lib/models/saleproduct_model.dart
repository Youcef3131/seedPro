class SaleProduct {
  final int id;
  final int quantitySold;
  final int productId;
  final int saleId;

  SaleProduct({
    required this.id,
    required this.quantitySold,
    required this.productId,
    required this.saleId,
  });

  factory SaleProduct.fromJson(Map<String, dynamic> json) {
    return SaleProduct(
      id: json['id'],
      quantitySold: json['quantity_sold'],
      productId: json['product'],
      saleId: json['sale'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity_sold': quantitySold,
      'product': productId,
      'sale': saleId,
    };
  }
}
