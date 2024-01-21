class SalePayment {
  final int id;
  final DateTime date;
  final double amount;
  final int sale;

  SalePayment({
    required this.id,
    required this.date,
    required this.amount,
    required this.sale,
  });

  factory SalePayment.fromJson(Map<String, dynamic> json) {
    return SalePayment(
      id: json['id'],
      date: DateTime.parse(json['date']),
      amount: double.parse(json['amount']),
      sale: json['sale'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount.toString(),
      'sale': sale,
    };
  }
}
