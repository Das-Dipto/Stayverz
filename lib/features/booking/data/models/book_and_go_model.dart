class BookAndGo {
  final bool success;
  final int statusCode;
  final String message;
  final MetaData metaData;
  final List<BookingData1> data;

  BookAndGo({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.metaData,
    required this.data,
  });

  factory BookAndGo.fromJson(Map<String, dynamic> json) {
    return BookAndGo(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      metaData: MetaData.fromJson(json['meta_data'] ?? {}),
      data: json['data'] != null
          ? List<BookingData1>.from(
        json['data'].map((x) => BookingData1.fromJson(x ?? {})),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "status_code": statusCode,
    "message": message,
    "meta_data": metaData.toJson(),
    "data": data.map((x) => x.toJson()).toList(),
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
      total: json['total'] ?? 0,
      pageSize: json['page_size'] is String
          ? int.tryParse(json['page_size']) ?? 0
          : (json['page_size'] ?? 0),
      next: json['next'],
      previous: json['previous'],
    );
  }

  Map<String, dynamic> toJson() => {
    "total": total,
    "page_size": pageSize,
    "next": next,
    "previous": previous,
  };
}
class BookingData1 {
  final int id;
  final String invoiceNo;
  final String checkIn;
  final String checkOut;
  final int nightCount;
  final double totalPrice;
  final String status;
  final Guest guest;
  final Host host;
  final Listing listing;

  BookingData1({
    required this.id,
    required this.invoiceNo,
    required this.checkIn,
    required this.checkOut,
    required this.nightCount,
    required this.totalPrice,
    required this.status,
    required this.guest,
    required this.host,
    required this.listing,
  });

  factory BookingData1.fromJson(Map<String, dynamic> json) {
    return BookingData1(
      id: json['id'] ?? 0,
      invoiceNo: json['invoice_no'] ?? '',
      checkIn: json['check_in'] ?? '',
      checkOut: json['check_out'] ?? '',
      nightCount: json['night_count'] ?? 0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      guest: Guest.fromJson(json['guest'] ?? {}),
      host: Host.fromJson(json['host'] ?? {}),
      listing: Listing.fromJson(json['listing'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoice_no": invoiceNo,
    "check_in": checkIn,
    "check_out": checkOut,
    "night_count": nightCount,
    "total_price": totalPrice,
    "status": status,
    "guest": guest.toJson(),
    "host": host.toJson(),
    "listing": listing.toJson(),
  };
}

class Guest {
  final int id;
  final String fullName;
  final String phoneNumber;

  Guest({required this.id, required this.fullName, required this.phoneNumber});

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
    id: json['id'] ?? 0,
    fullName: json['full_name'] ?? '',
    phoneNumber: json['phone_number'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "phone_number": phoneNumber,
  };
}

class Host {
  final int id;
  final String fullName;
  final String phoneNumber;

  Host({required this.id, required this.fullName, required this.phoneNumber});

  factory Host.fromJson(Map<String, dynamic> json) => Host(
    id: json['id'] ?? 0,
    fullName: json['full_name'] ?? '',
    phoneNumber: json['phone_number'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "phone_number": phoneNumber,
  };
}

class Listing {
  final int id;
  final String title;
  final String coverPhoto;
  final String address;

  Listing({
    required this.id,
    required this.title,
    required this.coverPhoto,
    required this.address,
  });

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
    id: json['id'] ?? 0,
    title: json['title'] ?? '',
    coverPhoto: json['cover_photo'] ?? '',
    address: json['address'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "cover_photo": coverPhoto,
    "address": address,
  };
}

// Hello I am Tamim