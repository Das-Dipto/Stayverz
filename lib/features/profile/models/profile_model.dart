import 'package:stayverz_flutter_app/features/profile/models/profile_details_model.dart';
import 'package:stayverz_flutter_app/features/profile/models/review_model.dart'
    hide ListingModel;
import 'package:stayverz_flutter_app/features/profile/models/listing_model.dart';

class ProfileModel {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String? phoneNumber;
  final String? email;
  final bool? isActive;
  final bool? isAvailableForCohosting;
  final String? status;
  final bool? isPhoneVerified;
  final bool? isEmailVerified;
  final String? uType;
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
  final ProfileDetailsModel? profile;
  final List<ReviewModel>? latestReviews;
  final List<ListingModel>? listings;
  final int? unreadMessageCount;
  final String? bio;
  final String? address;
  final Map<String, dynamic>? socialLinks;
  final List<String>? languages;
  final String? mongoUserId;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.phoneNumber,
    this.email,
    this.isActive,
    this.isAvailableForCohosting,
    this.status,
    this.isPhoneVerified,
    this.isEmailVerified,
    this.uType,
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
    this.profile,
    this.latestReviews,
    this.listings,
    this.unreadMessageCount,
    this.bio,
    this.address,
    this.socialLinks,
    this.languages,
    this.mongoUserId,
  });

  ProfileModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? username,
    String? phoneNumber,
    String? email,
    bool? isActive,
    bool? isAvailableForCohosting,
    String? status,
    bool? isPhoneVerified,
    bool? isEmailVerified,
    String? uType,
    String? countryCode,
    String? image,
    String? dateJoined,
    String? fullName,
    String? identityVerificationStatus,
    Map<String, dynamic>? identityVerificationImages,
    String? identityVerificationMethod,
    String? identityVerificationRejectReason,
    double? avgRating,
    int? totalRatingCount,
    List<dynamic>? wishlistListings,
    ProfileDetailsModel? profile,
    List<ReviewModel>? latestReviews,
    List<ListingModel>? listings,
    int? unreadMessageCount,
    String? bio,
    String? address,
    Map<String, dynamic>? socialLinks,
    List<String>? languages,
    String? mongoUserId,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      isAvailableForCohosting:
          isAvailableForCohosting ?? this.isAvailableForCohosting,
      status: status ?? this.status,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      uType: uType ?? this.uType,
      countryCode: countryCode ?? this.countryCode,
      image: image ?? this.image,
      dateJoined: dateJoined ?? this.dateJoined,
      fullName: fullName ?? this.fullName,
      identityVerificationStatus:
          identityVerificationStatus ?? this.identityVerificationStatus,
      identityVerificationImages:
          identityVerificationImages ?? this.identityVerificationImages,
      identityVerificationMethod:
          identityVerificationMethod ?? this.identityVerificationMethod,
      identityVerificationRejectReason:
          identityVerificationRejectReason ??
          this.identityVerificationRejectReason,
      avgRating: avgRating ?? this.avgRating,
      totalRatingCount: totalRatingCount ?? this.totalRatingCount,
      wishlistListings: wishlistListings ?? this.wishlistListings,
      profile: profile ?? this.profile,
      latestReviews: latestReviews ?? this.latestReviews,
      listings: listings ?? this.listings,
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
      bio: bio ?? this.bio,
      address: address ?? this.address,
      socialLinks: socialLinks ?? this.socialLinks,
      languages: languages ?? this.languages,
      mongoUserId: mongoUserId ?? this.mongoUserId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'phone_number': phoneNumber,
      'email': email,
      'is_active': isActive,
      'is_available_for_cohosting': isAvailableForCohosting,
      'status': status,
      'is_phone_verified': isPhoneVerified,
      'is_email_verified': isEmailVerified,
      'u_type': uType,
      'country_code': countryCode,
      'image': image,
      'date_joined': dateJoined,
      'full_name': fullName,
      'identity_verification_status': identityVerificationStatus,
      'identity_verification_images': identityVerificationImages,
      'identity_verification_method': identityVerificationMethod,
      'identity_verification_reject_reason': identityVerificationRejectReason,
      'avg_rating': avgRating,
      'total_rating_count': totalRatingCount,
      'wishlist_listings': wishlistListings,
      'profile': profile?.toJson(),
      'latest_reviews': latestReviews?.map((e) => e.toJson()).toList(),
      'listings': listings?.map((e) => e.toJson()).toList(),
      'unread_message_count': unreadMessageCount,
      'bio': bio,
      'address': address,
      'social_links': socialLinks,
      'languages': languages,
      'mongo_user_id': mongoUserId,
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      isActive: json['is_active'] ?? false,
      isAvailableForCohosting: json['is_available_for_cohosting'] ?? false,
      status: json['status'] ?? '',
      isPhoneVerified: json['is_phone_verified'] ?? false,
      isEmailVerified: json['is_email_verified'] ?? false,
      uType: json['u_type'] ?? '',
      countryCode: json['country_code'] ?? '',
      image: json['image'] ?? '',
      dateJoined: json['date_joined'] ?? '',
      fullName: json['full_name'] ?? '',
      identityVerificationStatus: json['identity_verification_status'] ?? '',
      identityVerificationImages: json['identity_verification_images'] ?? {},
      identityVerificationMethod: json['identity_verification_method'] ?? '',
      identityVerificationRejectReason:
          json['identity_verification_reject_reason'] ?? '',
      avgRating:
          (json['avg_rating'] is int)
              ? (json['avg_rating'] as int).toDouble()
              : (json['avg_rating'] ?? 0.0),
      totalRatingCount: json['total_rating_count'] ?? 0,
      wishlistListings: json['wishlist_listings'] ?? [],
      profile:
          json['profile'] != null
              ? ProfileDetailsModel.fromJson(json['profile'])
              : null,
      latestReviews:
          json['latest_reviews'] != null
              ? (json['latest_reviews'] as List)
                  .map((e) => ReviewModel.fromJson(e))
                  .toList()
              : null,
      listings:
          json['listings'] != null
              ? (json['listings'] as List)
                  .map((e) => ListingModel.fromJson(e))
                  .toList()
              : null,
      unreadMessageCount: json['unread_message_count'] ?? 0,
      bio: json['bio'] ?? '',
      address: json['address'] ?? '',
      socialLinks: json['social_links'] ?? {},
      languages:
          json['languages'] != null ? List<String>.from(json['languages']) : [],
      mongoUserId: json['mongo_user_id'],
    );
  }
}

// Hello I am Tamim