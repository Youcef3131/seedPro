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
      id: json['id'],
      date: DateTime.parse(json['date']),
      client: json['client'],
      clientName: json['client_name'],
      clientFirstName: json['client_first_name'],
      amountPaid: json['amountPaid'],
      total: json['total'],
      amountNotPaid: json['amount_not_paid'],
    );
  }
}
