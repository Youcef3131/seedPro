class Sale {
  final int id;
  final DateTime date;
  final int client;
  final String amountPaid;

  Sale({
    required this.id,
    required this.date,
    required this.client,
    required this.amountPaid,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      client: json['client'] as int,
      amountPaid: json['amountPaid'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'client': client,
      'amountPaid': amountPaid,
    };
  }
}

