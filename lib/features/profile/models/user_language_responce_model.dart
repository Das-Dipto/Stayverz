class PatchLanguagesResponse {
  final bool success;
  final int statusCode;
  final String message;
  final UserLanguagesData? data;

  PatchLanguagesResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory PatchLanguagesResponse.fromJson(Map<String, dynamic> json) {
    return PatchLanguagesResponse(
      success: json['success'] as bool? ?? false,
      statusCode: json['status_code'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? UserLanguagesData.fromJson(json['data']) : null,
    );
  }
}

class UserLanguagesData {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String school;
  final String work;
  final String address;
  final double latitude;
  final double longitude;
  final String bio;
  final List<String> languages;

  UserLanguagesData({
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.school,
    required this.work,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.bio,
    required this.languages,
  });

  factory UserLanguagesData.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return null;
      try {
        return DateTime.parse(dateStr);
      } catch (_) {
        return null;
      }
    }

    return UserLanguagesData(
      id: json['id'] as int? ?? 0,
      createdAt: parseDate(json['created_at'] as String?),
      updatedAt: parseDate(json['updated_at'] as String?),
      school: json['school'] as String? ?? '',
      work: json['work'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] is num) ? (json['latitude'] as num).toDouble() : 0.0,
      longitude: (json['longitude'] is num) ? (json['longitude'] as num).toDouble() : 0.0,
      bio: json['bio'] as String? ?? '',
      languages: (json['languages'] != null && json['languages'] is List)
          ? List<String>.from(json['languages'])
          : <String>[],
    );
  }
}

// Hello I am Tamim