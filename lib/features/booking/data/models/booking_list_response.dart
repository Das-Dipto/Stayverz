import 'booking_model.dart';

class BookingListResponse {
  final bool success;
  final int statusCode;
  final String message;
  final MetaData metaData;
  final List<BookingModel> data;

  BookingListResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.metaData,
    required this.data,
  });

  factory BookingListResponse.fromJson(Map<String, dynamic> json) {
    return BookingListResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      metaData: MetaData.fromJson(json['meta_data'] ?? {}),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'status_code': statusCode,
        'message': message,
        'meta_data': metaData.toJson(),
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class MetaData {
  final int total;
  final int pageSize;
  final int? next;
  final int? previous;

  MetaData({
    required this.total,
    required this.pageSize,
    this.next,
    this.previous,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      total: json['total'] is int ? json['total'] : int.tryParse(json['total'].toString()) ?? 0,
      pageSize: json['page_size'] is int ? json['page_size'] : int.tryParse(json['page_size'].toString()) ?? 0,
      next: json['next'] == null ? null : (json['next'] is int ? json['next'] : int.tryParse(json['next'].toString())),
      previous: json['previous'] == null ? null : (json['previous'] is int ? json['previous'] : int.tryParse(json['previous'].toString())),
    );
  }

  Map<String, dynamic> toJson() => {
        'total': total,
        'page_size': pageSize,
        'next': next,
        'previous': previous,
      };
}

// Hello I am Tamim