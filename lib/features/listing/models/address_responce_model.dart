class AddressResponse {
  final int statusCode;
  final AddressData? data;
  final int responseTime;

  AddressResponse({
    required this.statusCode,
    this.data,
    required this.responseTime,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      statusCode: json['statusCode'] ?? 0,
      data: json['data'] != null
          ? AddressData.fromJson(json['data'])
          : null,
      responseTime: json['responseTime'] ?? 0,
    );
  }
}
class AddressData {
  final String? id;
  final String? apartmentName;
  final String? propertyName;
  final String? country;
  final String? apartmentNo;
  final String area;
  final String? zipCode;
  final String division;
  final String district;
  final String thana;
  final String address;
  final Location? location;

  AddressData({
    this.id,
    this.apartmentName,
    this.propertyName,
    this.country,
    this.apartmentNo,
    required this.area,
    this.zipCode,
    required this.division,
    required this.district,
    required this.thana,
    required this.address,
    this.location,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) {
    return AddressData(
      id: json['id']?.toString(),
      apartmentName: json['apartment_name'],
      propertyName: json['property_name'],
      country: json['country'],
      apartmentNo: json['apartment_no'],
      area: json['area'] ?? '',
      zipCode: json['zip_code'],
      division: json['division'] ?? '',
      district: json['district'] ?? '',
      thana: json['thana'] ?? '',
      address: json['address'] ?? '',
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
    );
  }
}
class Location {
  final String? type;
  final double longitude;
  final double latitude;

  Location({
    this.type,
    required this.longitude,
    required this.latitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as List<dynamic>?;

    return Location(
      type: json['type'],
      longitude: coords != null && coords.isNotEmpty
          ? (coords[0] as num).toDouble()
          : 0.0,
      latitude: coords != null && coords.length > 1
          ? (coords[1] as num).toDouble()
          : 0.0,
    );
  }
}

// Hello I am Tamim