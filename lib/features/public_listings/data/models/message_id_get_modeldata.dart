class MessageBookingRequest {
  final int? listing;
  final int? toUser;
  final MessageBookingData? bookingData;
  final String? message;

  MessageBookingRequest({
    this.listing,
    this.toUser,
    this.bookingData,
    this.message,
  });

  Map<String, dynamic> toJson() {
    final cleanMessage = (message?.trim().isEmpty ?? true)
        ? 'Message from MessageBookingRequest'
        : message;

    return {
      'listing': listing,
      'to_user': toUser,
      'booking_data': bookingData?.toJson(),
      'message': cleanMessage,
    };
  }
}

class MessageBookingData {
  final String? checkIn;
  final String? checkOut;
  final int? adult;
  final int? children;
  final int? infant;
  final int? pets;
  final int? totalGuestCount;

  MessageBookingData({
    this.checkIn,
    this.checkOut,
    this.adult,
    this.children,
    this.infant,
    this.pets,
    this.totalGuestCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'check_in': checkIn,
      'check_out': checkOut,
      'adult': adult,
      'children': children,
      'infant': infant,
      'pets': pets,
      'total_guest_count': totalGuestCount,
    };
  }
}

class MessageBookingResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final MessageBookingResponseData? data;

  MessageBookingResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory MessageBookingResponse.fromJson(Map<String, dynamic> json) {
    return MessageBookingResponse(
      success: json['success'] as bool?,
      statusCode: json['status_code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? MessageBookingResponseData.fromJson(json['data'])
          : null,
    );
  }
}

class MessageBookingResponseData {
  final String? chatRoomId;
  final int? avgResponseTimeSeconds; // ADD THIS

  MessageBookingResponseData({
    this.chatRoomId,
    this.avgResponseTimeSeconds, // ADD THIS
  });

  factory MessageBookingResponseData.fromJson(Map<String, dynamic> json) {
    return MessageBookingResponseData(
      chatRoomId: json['chat_room_id'] as String?,
      avgResponseTimeSeconds: json['avg_response_time_seconds'] as int?, // ADD THIS
    );
  }
}

// Hello I am Tamim