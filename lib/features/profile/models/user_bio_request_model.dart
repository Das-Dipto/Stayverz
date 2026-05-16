class BioResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final BioUserData data;

  BioResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory BioResponseModel.fromJson(Map<String, dynamic> json) {
    return BioResponseModel(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: BioUserData.fromJson(json['data'] ?? {}),
    );
  }
}

class BioUserData {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? phoneNumber;
  final String? email;
  final bool? isActive;
  final String? status;
  final bool? isPhoneVerified;
  final bool? isEmailVerified;
  final String? userType;
  final String? countryCode;
  final String? image;
  final String? dateJoined;
  final String? fullName;
  final String? identityVerificationStatus;
  final Map<String, dynamic>? identityVerificationImages;
  final String? identityVerificationMethod;
  final String? identityVerificationRejectReason;
  final double? avgRating;
  final int? totalRatingCount;
  final List<dynamic>? wishlistListings;
  final bool? isAvailableForCohosting;
  final BioData? profile;

  BioUserData({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.phoneNumber,
    this.email,
    this.isActive,
    this.status,
    this.isPhoneVerified,
    this.isEmailVerified,
    this.userType,
    this.countryCode,
    this.image,
    this.dateJoined,
    this.fullName,
    this.identityVerificationStatus,
    this.identityVerificationImages,
    this.identityVerificationMethod,
    this.identityVerificationRejectReason,
    this.avgRating,
    this.totalRatingCount,
    this.wishlistListings,
    this.isAvailableForCohosting,
    this.profile,
  });

  factory BioUserData.fromJson(Map<String, dynamic> json) {
    return BioUserData(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      isActive: json['is_active'],
      status: json['status'],
      isPhoneVerified: json['is_phone_verified'],
      isEmailVerified: json['is_email_verified'],
      userType: json['u_type'],
      countryCode: json['country_code'],
      image: json['image'],
      dateJoined: json['date_joined'],
      fullName: json['full_name'],
      identityVerificationStatus: json['identity_verification_status'],
      identityVerificationImages: json['identity_verification_images'],
      identityVerificationMethod: json['identity_verification_method'],
      identityVerificationRejectReason: json['identity_verification_reject_reason'],
      avgRating: (json['avg_rating'] as num?)?.toDouble(),
      totalRatingCount: json['total_rating_count'] ?? 0,
      wishlistListings: json['wishlist_listings'],
      isAvailableForCohosting: json['is_available_for_cohosting'],
      profile: json['profile'] != null ? BioData.fromJson(json['profile']) : null,
    );
  }
}

class BioData {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? school;
  final String? work;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? bio;
  final List<String>? languages;
  final String? emergencyContact;
  final int? userId;
  final String? gender;  // Added gender field

  BioData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.school,
    this.work,
    this.address,
    this.latitude,
    this.longitude,
    this.bio,
    this.languages,
    this.emergencyContact,
    this.userId,
    this.gender,  // Include in constructor
  });

  factory BioData.fromJson(Map<String, dynamic> json) {
    return BioData(
      id: json['id'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      school: json['school'],
      work: json['work'],
      address: json['address'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      bio: json['bio'],
      languages: (json['languages'] as List?)?.map((e) => e.toString()).toList(),
      emergencyContact: json['emergency_contact'],
      userId: json['user'],
      gender: json['gender'] as String?,  // Deserialize gender safely
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'school': school,
      'work': work,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'bio': bio,
      'languages': languages,
      'emergency_contact': emergencyContact,
      'user': userId,
      'gender': gender,  // Serialize gender
    };
  }
}


// Hello I am Tamim