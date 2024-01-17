


class ExtendedSale {
  final int id;
  final DateTime date;
  final int client;
  final String clientName;
  final String clientFirstName;
  final String amountPaid;
  final double total;
  final double amountNotPaid;

  ExtendedSale({
    required this.id,
    required this.date,
    required this.client,
    required this.clientName,
    required this.clientFirstName,
    required this.amountPaid,
    required this.total,
    required this.amountNotPaid,
  });

  factory ExtendedSale.fromJson(Map<String, dynamic> json) {
    return ExtendedSale(
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      client: json['client'] as int,
      clientName: json['client_name'] as String,
      clientFirstName: json['client_first_name'] as String,
      amountPaid: json['amountPaid'] as String,
      total: json['total'] as double,
      amountNotPaid: json['amount_not_paid'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'client': client,
      'client_name': clientName,
      'client_first_name': clientFirstName,
      'amountPaid': amountPaid,
      'total': total,
      'amount_not_paid': amountNotPaid,
    };
  }
}
