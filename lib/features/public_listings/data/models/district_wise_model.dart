class DistrictWideLatLong {
  final String name;
  final double latitude;
  final double longitude;

  DistrictWideLatLong({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory DistrictWideLatLong.fromJson(Map<String, dynamic> json) {
    return DistrictWideLatLong(
      name: json['name'],
      latitude: json['lat'].toDouble(),
      longitude: json['long'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'lat': latitude,
    'long': longitude,
  };

  // 👉 Add these to fix the Dropdown matching issue:
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DistrictWideLatLong &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              latitude == other.latitude &&
              longitude == other.longitude;

  @override
  int get hashCode => name.hashCode ^ latitude.hashCode ^ longitude.hashCode;
}


class DistrictWideLatLongResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<DistrictWideLatLong> districtList;

  DistrictWideLatLongResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.districtList,
  });

  factory DistrictWideLatLongResponse.fromJson(Map<String, dynamic> json) {
    return DistrictWideLatLongResponse(
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
      districtList: List<DistrictWideLatLong>.from(
        json['data'].map((item) => DistrictWideLatLong.fromJson(item)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status_code': statusCode,
      'message': message,
      'data': districtList.map((e) => e.toJson()).toList(),
    };
  }
}

// Hello I am Tamim