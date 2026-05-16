// models/division_district_thana_model.dart

class DivisionDistrictThanaResponse {
  final int? statusCode;
  final List<DivisionModel> data;
  final int? responseTime;

  DivisionDistrictThanaResponse({
    this.statusCode,
    this.data = const [],
    this.responseTime,
  });

  factory DivisionDistrictThanaResponse.fromJson(Map<String, dynamic> json) {
    return DivisionDistrictThanaResponse(
      statusCode: json['statusCode'] as int?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DivisionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      responseTime: json['responseTime'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'statusCode': statusCode,
    'data': data.map((e) => e.toJson()).toList(),
    'responseTime': responseTime,
  };
}

// ---------------------------------------------------------------------------

class DivisionModel {
  final String division;
  final List<DistrictModel> districts;

  DivisionModel({
    required this.division,
    this.districts = const [],
  });

  /// Trimmed, safe getter — never returns null or extra spaces
  String get divisionName => division.trim();

  bool get hasDistricts => districts.isNotEmpty;

  factory DivisionModel.fromJson(Map<String, dynamic> json) {
    return DivisionModel(
      division: (json['division'] as String? ?? '').trim(),
      districts: (json['districts'] as List<dynamic>?)
          ?.map((e) => DistrictModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'division': division,
    'districts': districts.map((e) => e.toJson()).toList(),
  };
}

// ---------------------------------------------------------------------------

class DistrictModel {
  final String district;
  final String division;
  final List<ThanaModel> thanas;

  DistrictModel({
    required this.district,
    required this.division,
    this.thanas = const [],
  });

  /// Trimmed, safe getters
  String get districtName => district.trim();
  String get divisionName => division.trim();

  bool get hasThanas => thanas.isNotEmpty;

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      district: (json['district'] as String? ?? '').trim(),
      division: (json['division'] as String? ?? '').trim(),
      thanas: (json['thanas'] as List<dynamic>?)
          ?.map((e) => ThanaModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'district': district,
    'division': division,
    'thanas': thanas.map((e) => e.toJson()).toList(),
  };
}

// ---------------------------------------------------------------------------

class ThanaModel {
  final String thana;
  final String district;

  ThanaModel({
    required this.thana,
    required this.district,
  });

  /// Trimmed, safe getters
  String get thanaName => thana.trim();
  String get districtName => district.trim();

  factory ThanaModel.fromJson(Map<String, dynamic> json) {
    return ThanaModel(
      thana: (json['thana'] as String? ?? '').trim(),
      district: (json['district'] as String? ?? '').trim(),
    );
  }

  Map<String, dynamic> toJson() => {
    'thana': thana,
    'district': district,
  };
}