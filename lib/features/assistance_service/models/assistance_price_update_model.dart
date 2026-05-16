class AssistancePriceUpdatePayload {
  final int id;
  final String price;
  final bool isBlocked;
  final String note;
  final String startDate;
  final String endDate;

  AssistancePriceUpdatePayload({
    required this.id,
    required this.price,
    required this.isBlocked,
    required this.note,
    required this.startDate,
    required this.endDate,
  });

  factory AssistancePriceUpdatePayload.fromJson(Map<String, dynamic> json) {
    return AssistancePriceUpdatePayload(
      id: json['id'],
      price: json['price'],
      isBlocked: json['isBlocked'],
      note: json['note'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'isBlocked': isBlocked,
      'note': note,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

// Hello I am Tamim