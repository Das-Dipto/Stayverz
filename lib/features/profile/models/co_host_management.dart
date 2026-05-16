class UpdateCoHostResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final CoHostRespoceData data;

  UpdateCoHostResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory UpdateCoHostResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateCoHostResponseModel(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: CoHostRespoceData.fromJson(json['data']),
    );
  }
}

class CoHostRespoceData {
  final int id;
  final ListingDetails listingDetails;
  final CoHostUserDetails coHostUserDetails;
  final String accessLevel;
  final String commissionPercentage;
  final bool isActive;
  final String createdAt;

  CoHostRespoceData({
    required this.id,
    required this.listingDetails,
    required this.coHostUserDetails,
    required this.accessLevel,
    required this.commissionPercentage,
    required this.isActive,
    required this.createdAt,
  });

  factory CoHostRespoceData.fromJson(Map<String, dynamic> json) {
    return CoHostRespoceData(
      id: json['id'],
      listingDetails: ListingDetails.fromJson(json['listing_details']),
      coHostUserDetails: CoHostUserDetails.fromJson(json['co_host_user_details']),
      accessLevel: json['access_level'] ?? '',
      commissionPercentage: json['commission_percentage'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}

class ListingDetails {
  final int id;
  final String title;
  final String coverPhoto;

  ListingDetails({
    required this.id,
    required this.title,
    required this.coverPhoto,
  });

  factory ListingDetails.fromJson(Map<String, dynamic> json) {
    return ListingDetails(
      id: json['id'],
      title: json['title'] ?? '',
      coverPhoto: json['cover_photo'] ?? '',
    );
  }
}

class CoHostUserDetails {
  final int id;
  final String fullName;
  final String username;
  final String image;
  final String uType;

  CoHostUserDetails({
    required this.id,
    required this.fullName,
    required this.username,
    required this.image,
    required this.uType,
  });

  factory CoHostUserDetails.fromJson(Map<String, dynamic> json) {
    return CoHostUserDetails(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      username: json['username'] ?? '',
      image: json['image'] ?? '',
      uType: json['u_type'] ?? '',
    );
  }
}
class UpdateCoHostCommissionRequest {
  final String commissionPercentage;

  UpdateCoHostCommissionRequest({required this.commissionPercentage});

  Map<String, dynamic> toJson() {
    return {
      'commission_percentage': commissionPercentage,
    };
  }
}

// Hello I am Tamim