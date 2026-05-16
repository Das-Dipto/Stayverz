class UserAddressLocationModel {
  final String address;
  final double latitude;
  final double longitude;

  UserAddressLocationModel({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory UserAddressLocationModel.fromJson(Map<String, dynamic> json) {
    return UserAddressLocationModel(
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

// Hello I am Tamim