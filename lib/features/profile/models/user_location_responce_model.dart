class UserAddressLocationData {
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

  UserAddressLocationData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.school,
    required this.work,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.bio,
    required this.languages,
  });

  factory UserAddressLocationData.fromJson(Map<String, dynamic> json) {
    return UserAddressLocationData(
      id: json['id'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      school: json['school'] ?? '',
      work: json['work'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      bio: json['bio'] ?? '',
      languages: (json['languages'] as List?)?.map((e) => e.toString()).toList() ?? [],
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
    };
  }
}

// Hello I am Tamim