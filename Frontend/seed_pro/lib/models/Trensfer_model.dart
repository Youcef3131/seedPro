class Transfer {
  final int id;
  final DateTime date;
  final int sourceShop;
  final int destShop;

  Transfer({
    required this.id,
    required this.date,
    required this.sourceShop,
    required this.destShop,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      id: json['id'],
      date: DateTime.parse(json['date']),
      sourceShop: json['source_shop'],
      destShop: json['dest_shop'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'source_shop': sourceShop,
      'dest_shop': destShop,
    };
  }
}
