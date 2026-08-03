class ReferralHostListItem {
  final String referralCode;
  final String status;
  final DateTime? referralDate;
  final String? hostName;
  final String? hostEmail;
  final int propertiesCount;
  final String? tier;
  final double? rating;
  final int bookingsCount;
  final double totalBookingValue;
  final double rewardEarned;

  ReferralHostListItem({
    required this.referralCode,
    required this.status,
    this.referralDate,
    this.hostName,
    this.hostEmail,
    required this.propertiesCount,
    this.tier,
    this.rating,
    required this.bookingsCount,
    required this.totalBookingValue,
    required this.rewardEarned,
  });

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  factory ReferralHostListItem.fromJson(Map<String, dynamic> json) {
    return ReferralHostListItem(
      referralCode: json['referral_code']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      referralDate: json['referral_date'] != null
          ? DateTime.tryParse(json['referral_date'].toString())
          : null,
      hostName: json['host_name']?.toString(),
      hostEmail: json['host_email']?.toString(),
      propertiesCount: _toInt(json['properties_count']),
      tier: json['tier']?.toString(),
      rating: json['rating'] != null ? _toDouble(json['rating']) : null,
      bookingsCount: _toInt(json['bookings_count']),
      totalBookingValue: _toDouble(json['total_booking_value']),
      rewardEarned: _toDouble(json['reward_earned']),
    );
  }
}

// Hello I am Tamim