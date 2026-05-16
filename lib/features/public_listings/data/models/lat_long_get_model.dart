class LocationResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<LocationData> data;

  LocationResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => LocationData.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class LocationData {
  final int id;
  final String name;
  final CenterPoint center;

  LocationData({
    required this.id,
    required this.name,
    required this.center,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      center: CenterPoint.fromJson(json['center'] ?? {}),
    );
  }
}

class CenterPoint {
  final String type;
  final List<double> coordinates;

  CenterPoint({
    required this.type,
    required this.coordinates,
  });

  factory CenterPoint.fromJson(Map<String, dynamic> json) {
    return CenterPoint(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
          [],
    );
  }

  double? get latitude => coordinates.length > 1 ? coordinates[1] : null;
  double? get longitude => coordinates.isNotEmpty ? coordinates[0] : null;
}

// Hello I am Tamim