class ReferralGuestListItem {
  final String referralCode;
  final String status;
  final DateTime? referralDate;
  final String? referredUser;
  final String? referredEmail;
  final bool? isActive;
  final int bookingsMade;
  final int maxBookings;
  final double rewardEarned;
  final int rewardCount;

  ReferralGuestListItem({
    required this.referralCode,
    required this.status,
    this.referralDate,
    this.referredUser,
    this.referredEmail,
    this.isActive,
    required this.bookingsMade,
    required this.maxBookings,
    required this.rewardEarned,
    required this.rewardCount,
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

  factory ReferralGuestListItem.fromJson(Map<String, dynamic> json) {
    return ReferralGuestListItem(
      referralCode: json['referral_code']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      referralDate: json['referral_date'] != null
          ? DateTime.tryParse(json['referral_date'].toString())
          : null,
      referredUser: json['referred_user']?.toString(),
      referredEmail: json['referred_email']?.toString(),
      isActive: json['is_active'] is bool ? json['is_active'] : null,
      bookingsMade: _toInt(json['bookings_made']),
      maxBookings: _toInt(json['max_bookings']),
      rewardEarned: _toDouble(json['reward_earned']),
      rewardCount: _toInt(json['reward_count']),
    );
  }
}

// Hello I am Tamim