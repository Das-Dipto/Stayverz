class ProfileDetailsModel {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String school;
  final String work;
  final String address;
  final double latitude;
  final double longitude;
  final String bio;
  final List<String> languages;
  final String emergencyContact;
  final String? gender;  // NEW nullable field
  final int user;

  ProfileDetailsModel({
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
    required this.emergencyContact,
    this.gender,
    required this.user,
  });

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProfileDetailsModel(
      id: json['id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      school: json['school'] ?? '',
      work: json['work'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      bio: json['bio'] ?? '',
      languages: (json['languages'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      emergencyContact: json['emergency_contact'] ?? '',
      gender: (json['gender'] as String?)?.isEmpty ?? true ? null : json['gender'],
      user: json['user'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'school': school,
      'work': work,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'bio': bio,
      'languages': languages,
      'emergency_contact': emergencyContact,
      'gender': gender,
      'user': user,
    };
  }
}

// Hello I am Tamim