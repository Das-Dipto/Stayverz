class SectionResponse {
  final int? statusCode;
  final List<SectionModel> data;

  SectionResponse({
    this.statusCode,
    required this.data,
  });

factory SectionResponse.fromJson(Map<String, dynamic> json) {
  return SectionResponse(
    statusCode: json['status_code'] as int?,  // ✅ fix key
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => SectionModel.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
  );
}

  Map<String, dynamic> toJson() => {
    'statusCode': statusCode,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class SectionModel {
  final int? id;
  final String? displayName;
  final String? subText;
  final double? lat;
  final double? long;

  SectionModel({
    this.id,
    this.displayName,
    this.subText,
    this.lat,
    this.long,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] as int?,
      displayName: json['address'] as String? ?? '',
      subText: json['sub_text'] as String? ?? '',
      lat: (json['latitude'] != null)
          ? double.tryParse(json['latitude'].toString())
          : null,
      long: (json['longitude'] != null)
          ? double.tryParse(json['longitude'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'display_name': displayName,
    'sub_text': subText,
    'lat': lat,
    'long': long,
  };
}

// Hello I am Tamim