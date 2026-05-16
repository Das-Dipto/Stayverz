import 'dart:convert';

class AssistanceCancellationPolicesResponse {
  final int? status;
  final String? message;
  final List<AssistanceCancellationPolices>? data;
  final DateTime? timestamp;

  AssistanceCancellationPolicesResponse({
    this.status,
    this.message,
    this.data,
    this.timestamp,
  });

  factory AssistanceCancellationPolicesResponse.fromRawJson(String str) => AssistanceCancellationPolicesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssistanceCancellationPolicesResponse.fromJson(Map<String, dynamic> json) => AssistanceCancellationPolicesResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<AssistanceCancellationPolices>.from(json["data"]!.map((x) => AssistanceCancellationPolices.fromJson(x))),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "timestamp": timestamp?.toIso8601String(),
  };
}

class AssistanceCancellationPolices {
  final int? id;
  final String? policyName;
  final String? description;
  final int? refundPercentage;
  final int? cancellationDeadline;

  AssistanceCancellationPolices({
    this.id,
    this.policyName,
    this.description,
    this.refundPercentage,
    this.cancellationDeadline,
  });

  factory AssistanceCancellationPolices.fromRawJson(String str) => AssistanceCancellationPolices.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssistanceCancellationPolices.fromJson(Map<String, dynamic> json) => AssistanceCancellationPolices(
    id: json["id"],
    policyName: json["policy_name"],
    description: json["description"],
    refundPercentage: json["refund_percentage"],
    cancellationDeadline: json["cancellation_deadline"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "policy_name": policyName,
    "description": description,
    "refund_percentage": refundPercentage,
    "cancellation_deadline": cancellationDeadline,
  };
}

// Hello I am Tamim