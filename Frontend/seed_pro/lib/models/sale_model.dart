class Sale {
  final int id;
  final DateTime date;
  final int clientId;
  final double amountPaid;

  Sale({
    required this.id,
    required this.date,
    required this.clientId,
    required this.amountPaid,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      date: DateTime.parse(json['date']),
      clientId: json['client'],
      amountPaid: json['amountPaid'] != null
          ? double.tryParse(json['amountPaid'].toString()) ?? 0.0
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'client': clientId,
      'amountPaid': amountPaid.toString(),
    };
  }
}
