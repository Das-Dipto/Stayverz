class ReferralResponseList {
  final bool success;
  final int statusCode;
  final String message;
  final MetaData metaData;
  final List<ReferralDataList> data;
  final String? last; // new field added

  ReferralResponseList({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.metaData,
    required this.data,
    this.last,
  });

  factory ReferralResponseList.fromJson(Map<String, dynamic> json) {
    return ReferralResponseList(
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
      metaData: MetaData.fromJson(json['meta_data']),
      data: (json['data'] as List)
          .map((item) => ReferralDataList.fromJson(item))
          .toList(),
      last: json['last'],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'status_code': statusCode,
    'message': message,
    'meta_data': metaData.toJson(),
    'data': data.map((e) => e.toJson()).toList(),
    if (last != null) 'last': last,
  };
}

class MetaData {
  final int total;
  final String pageSize;
  final String? next;
  final String? previous;

  MetaData({
    required this.total,
    required this.pageSize,
    this.next,
    this.previous,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      total: json['total'],
      pageSize: json['page_size'],
      next: json['next'],
      previous: json['previous'],
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'page_size': pageSize,
    'next': next,
    'previous': previous,
  };
}

class ReferralDataList {
  final int id;
  final Referrer referrer;
  final String referralCode;
  final String referralType;
  final String referralTypeDisplay;
  final ReferredUser? referredUser;
  final String status;
  final String statusDisplay;
  final int rewardedBookingCount;
  final int maxRewardableBookings;
  final String rewardValueFromThisReferral;
  final String rewardUnitFromThisReferral;
  final bool isActiveForRewards;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String referralLink;

  ReferralDataList({
    required this.id,
    required this.referrer,
    required this.referralCode,
    required this.referralType,
    required this.referralTypeDisplay,
    this.referredUser,
    required this.status,
    required this.statusDisplay,
    required this.rewardedBookingCount,
    required this.maxRewardableBookings,
    required this.rewardValueFromThisReferral,
    required this.rewardUnitFromThisReferral,
    required this.isActiveForRewards,
    required this.createdAt,
    required this.updatedAt,
    required this.referralLink,
  });

  factory ReferralDataList.fromJson(Map<String, dynamic> json) {
    return ReferralDataList(
      id: json['id'],
      referrer: Referrer.fromJson(json['referrer']),
      referralCode: json['referral_code'],
      referralType: json['referral_type'],
      referralTypeDisplay: json['referral_type_display'],
      referredUser: json['referred_user'] != null
          ? ReferredUser.fromJson(json['referred_user'])
          : null,
      status: json['status'],
      statusDisplay: json['status_display'],
      rewardedBookingCount: json['rewarded_booking_count'],
      maxRewardableBookings: json['max_rewardable_bookings'],
      rewardValueFromThisReferral: json['reward_value_from_this_referral'],
      rewardUnitFromThisReferral: json['reward_unit_from_this_referral'],
      isActiveForRewards: json['is_active_for_rewards'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      referralLink: json['referral_link'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'referrer': referrer.toJson(),
    'referral_code': referralCode,
    'referral_type': referralType,
    'referral_type_display': referralTypeDisplay,
    'referred_user': referredUser?.toJson(),
    'status': status,
    'status_display': statusDisplay,
    'rewarded_booking_count': rewardedBookingCount,
    'max_rewardable_bookings': maxRewardableBookings,
    'reward_value_from_this_referral': rewardValueFromThisReferral,
    'reward_unit_from_this_referral': rewardUnitFromThisReferral,
    'is_active_for_rewards': isActiveForRewards,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'referral_link': referralLink,
  };
}

class Referrer {
  final int id;
  final String username;
  final String fullName;
  final String uType;

  Referrer({
    required this.id,
    required this.username,
    required this.fullName,
    required this.uType,
  });

  factory Referrer.fromJson(Map<String, dynamic> json) {
    return Referrer(
      id: json['id'],
      username: json['username'],
      fullName: json['full_name'],
      uType: json['u_type'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'full_name': fullName,
    'u_type': uType,
  };
}

class ReferredUser {
  final int id;
  final String username;
  final String fullName;
  final String uType;
  final String image;

  ReferredUser({
    required this.id,
    required this.username,
    required this.fullName,
    required this.uType,
    required this.image,
  });

  factory ReferredUser.fromJson(Map<String, dynamic> json) {
    return ReferredUser(
      id: json['id'],
      username: json['username'],
      fullName: json['full_name'],
      uType: json['u_type'],
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'full_name': fullName,
    'u_type': uType,
    'image': image,
  };
}

// Hello I am Tamim