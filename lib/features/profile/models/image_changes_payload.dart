class UploadImageRequest {
  final String image;

  UploadImageRequest({required this.image});

  Map<String, dynamic> toJson() => {
    'image': image,
  };
}

class UploadImageResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final UploadImageData? data;

  UploadImageResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory UploadImageResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UploadImageResponse();

    return UploadImageResponse(
      success: json['success'] as bool?,
      statusCode: json['status_code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? UploadImageData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class UploadImageData {
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

  UploadImageData({
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
  });

  factory UploadImageData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UploadImageData();

    return UploadImageData(
      id: json['id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      school: json['school'] as String?,
      work: json['work'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] != null)
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: (json['longitude'] != null)
          ? (json['longitude'] as num).toDouble()
          : null,
      bio: json['bio'] as String?,
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
    );
  }
}

// Hello I am Tamim