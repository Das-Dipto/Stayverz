class UserWorkfileResponse {
  final bool success;
  final int statusCode;
  final String message;
  final UserWorkProfileData data; // Updated type

  UserWorkfileResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory UserWorkfileResponse.fromJson(Map<String, dynamic> json) {
    return UserWorkfileResponse(
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
      data: UserWorkProfileData.fromJson(json['data']), // Updated type
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status_code': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}
class UserWorkProfileData {
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
  final String? gender; // Added gender field

  UserWorkProfileData({
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
    this.gender, // Include in constructor
  });

  factory UserWorkProfileData.fromJson(Map<String, dynamic> json) {
    return UserWorkProfileData(
      id: json['id'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      school: json['school'] as String?,
      work: json['work'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      bio: json['bio'] as String?,
      languages: (json['languages'] as List?)?.map((e) => e.toString()).toList(),
      gender: json['gender'] as String?, // Deserialize gender
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
      'gender': gender, // Serialize gender
    };
  }
}



// Hello I am Tamim