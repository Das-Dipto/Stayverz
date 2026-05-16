class PatchUserProfileRequest {
  final String? school;
  final String? work;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? bio;
  final List<String>? languages;

  PatchUserProfileRequest({
    this.school,
    this.work,
    this.address,
    this.latitude,
    this.longitude,
    this.bio,
    this.languages,
  });

  factory PatchUserProfileRequest.fromJson(Map<String, dynamic> json) {
    return PatchUserProfileRequest(
      school: json['school'] as String?,
      work: json['work'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] != null) ? (json['latitude'] as num).toDouble() : null,
      longitude: (json['longitude'] != null) ? (json['longitude'] as num).toDouble() : null,
      bio: json['bio'] as String?,
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (school != null) 'school': school,
      if (work != null) 'work': work,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (bio != null) 'bio': bio,
      if (languages != null) 'languages': languages,
    };
  }
}

// Hello I am Tamim