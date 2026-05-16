class AmenitiesResponseModel {
  final int? statusCode;
  final List<AmenitiesCategoryModel>? data;
  final int? responseTime;

  AmenitiesResponseModel({
    this.statusCode,
    this.data,
    this.responseTime,
  });

  factory AmenitiesResponseModel.fromJson(Map<String, dynamic> json) {
    return AmenitiesResponseModel(
      statusCode: json['statusCode'],
      responseTime: json['responseTime'],
      data: json['data'] == null
          ? []
          : List<AmenitiesCategoryModel>.from(
        json['data'].map((x) => AmenitiesCategoryModel.fromJson(x)),
      ),
    );
  }
}
class AmenitiesCategoryModel {
  final String? title;
  final List<AmenityModel>? data;

  AmenitiesCategoryModel({
    this.title,
    this.data,
  });

  factory AmenitiesCategoryModel.fromJson(Map<String, dynamic> json) {
    return AmenitiesCategoryModel(
      title: json['title'],
      data: json['data'] == null
          ? []
          : List<AmenityModel>.from(
        json['data'].map((x) => AmenityModel.fromJson(x)),
      ),
    );
  }
}
class AmenityModel {
  final int? id;
  final String? name;
  final String? iconMobile;
  final String? icon;
  final bool? status;
  final String? aType;
  final String? category;
  final bool? newState;

  AmenityModel({
    this.id,
    this.name,
    this.iconMobile,
    this.icon,
    this.status,
    this.aType,
    this.category,
    this.newState,
  });

  factory AmenityModel.fromJson(Map<String, dynamic> json) {
    return AmenityModel(
      id: json['id'],
      name: json['name'],
      iconMobile: json['icon_mobile'],
      icon: json['icon'],
      status: json['status'],
      aType: json['a_type'],
      category: json['category'],
      newState: json['new_state'],
    );
  }
}
class UpdateAmenitiesRequest {
  final List<int> amenityIds;

  UpdateAmenitiesRequest({
    required this.amenityIds,
  });

  Map<String, dynamic> toJson() {
    return {
      "amenityIds": amenityIds,
    };
  }
}

// Hello I am Tamim