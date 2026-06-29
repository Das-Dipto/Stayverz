class BookingPostModel {
  final  listing;
  final String checkIn;
  final String checkOut;
  final String? couponCode;
  final int? childrenCount;
  final int? infantCount;
  final int? adultCount;

  BookingPostModel({
    required this.listing,
    required this.checkIn,
    required this.checkOut,
    this.childrenCount,
    this.infantCount,
    this.adultCount,
    this.couponCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'listing': listing,
      'check_in': checkIn,
      'check_out': checkOut,
      if (couponCode != null)'coupon_code': couponCode,
      if (childrenCount != null) 'children_count': childrenCount,
      if (infantCount != null) 'infant_count': infantCount,
      if (adultCount != null) 'adult_count': adultCount,
    };
  }
}

// Hello I am Tamim