class ReferralHostEarnings {
  final int totalReferrals;
  final int totalHostsReferred;
  final int activeHosts;
  final int activeReferrals;
  final double totalRewards;
  final double totalEarned;
  final double completedEarned;
  final int bookingsReferred;
  final double totalBookingValue;
  final double totalHostPayout;
  final DateTime? firstReward;
  final DateTime? lastReward;
  final double avgProperties;
  final int superhostCount;
  final int pointsBalance;
  final double referralBalance;
  final double hostReferralCreditBalance;
  final double lifetimeEarnings;
  final int myProperties;
  final double myTotalSales;
  final String? myTier;
  final double bookingsPerHost;
  final double revenuePerHost;
  final double progressPercentage;

  ReferralHostEarnings({
    required this.totalReferrals,
    required this.totalHostsReferred,
    required this.activeHosts,
    required this.activeReferrals,
    required this.totalRewards,
    required this.totalEarned,
    required this.completedEarned,
    required this.bookingsReferred,
    required this.totalBookingValue,
    required this.totalHostPayout,
    this.firstReward,
    this.lastReward,
    required this.avgProperties,
    required this.superhostCount,
    required this.pointsBalance,
    required this.referralBalance,
    required this.hostReferralCreditBalance,
    required this.lifetimeEarnings,
    required this.myProperties,
    required this.myTotalSales,
    this.myTier,
    required this.bookingsPerHost,
    required this.revenuePerHost,
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

  factory ReferralHostEarnings.fromJson(Map<String, dynamic> json) {
    return ReferralHostEarnings(
      totalReferrals: _toInt(json['total_referrals']),
      totalHostsReferred: _toInt(json['total_hosts_referred']),
      activeHosts: _toInt(json['active_hosts']),
      activeReferrals: _toInt(json['active_referrals']),
      totalRewards: _toDouble(json['total_rewards']),
      totalEarned: _toDouble(json['total_earned']),
      completedEarned: _toDouble(json['completed_earned']),
      bookingsReferred: _toInt(json['bookings_referred']),
      totalBookingValue: _toDouble(json['total_booking_value']),
      totalHostPayout: _toDouble(json['total_host_payout']),
      firstReward: _toDate(json['first_reward']),
      lastReward: _toDate(json['last_reward']),
      avgProperties: _toDouble(json['avg_properties']),
      superhostCount: _toInt(json['superhost_count']),
      pointsBalance: _toInt(json['points_balance']),
      referralBalance: _toDouble(json['referral_balance']),
      hostReferralCreditBalance: _toDouble(json['host_referral_credit_balance']),
      lifetimeEarnings: _toDouble(json['lifetime_earnings']),
      myProperties: _toInt(json['my_properties']),
      myTotalSales: _toDouble(json['my_total_sales']),
      myTier: json['my_tier']?.toString(),
      bookingsPerHost: _toDouble(json['bookings_per_host']),
      revenuePerHost: _toDouble(json['revenue_per_host']),
      progressPercentage: _toDouble(json['progress_percentage']),
    );
  }
}

// Hello I am Tamim