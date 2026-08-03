class ReferralGuestEarnings {
  final int totalReferrals;
  final int totalReferredPeople;
  final int activeReferred;
  final int activeReferrals;
  final double totalRewards;
  final double totalEarned;
  final double completedEarned;
  final int bookingsReferred;
  final double totalBookingValue;
  final DateTime? firstReward;
  final DateTime? lastReward;
  final int pointsBalance;
  final double referralBalance;
  final double lifetimeEarnings;
  final double progressPercentage;

  ReferralGuestEarnings({
    required this.totalReferrals,
    required this.totalReferredPeople,
    required this.activeReferred,
    required this.activeReferrals,
    required this.totalRewards,
    required this.totalEarned,
    required this.completedEarned,
    required this.bookingsReferred,
    required this.totalBookingValue,
    this.firstReward,
    this.lastReward,
    required this.pointsBalance,
    required this.referralBalance,
    required this.lifetimeEarnings,
    required this.progressPercentage,
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

  static DateTime? _toDate(dynamic v) {
    if (v == null) return null;
    try {
      return DateTime.parse(v.toString());
    } catch (_) {
      return null;
    }
  }

  factory ReferralGuestEarnings.fromJson(Map<String, dynamic> json) {
    return ReferralGuestEarnings(
      totalReferrals: _toInt(json['total_referrals']),
      totalReferredPeople: _toInt(json['total_referred_people']),
      activeReferred: _toInt(json['active_referred']),
      activeReferrals: _toInt(json['active_referrals']),
      totalRewards: _toDouble(json['total_rewards']),
      totalEarned: _toDouble(json['total_earned']),
      completedEarned: _toDouble(json['completed_earned']),
      bookingsReferred: _toInt(json['bookings_referred']),
      totalBookingValue: _toDouble(json['total_booking_value']),
      firstReward: _toDate(json['first_reward']),
      lastReward: _toDate(json['last_reward']),
      pointsBalance: _toInt(json['points_balance']),
      referralBalance: _toDouble(json['referral_balance']),
      lifetimeEarnings: _toDouble(json['lifetime_earnings']),
      progressPercentage: _toDouble(json['progress_percentage']),
    );
  }
}

// Hello I am Tamim