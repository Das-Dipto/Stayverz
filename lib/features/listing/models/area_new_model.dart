class AreaModel {
  final String? area;
  final String? thana;
  final String? district;
  final String? division;

  AreaModel({
    this.area,
    this.thana,
    this.district,
    this.division,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      area: json['area'],
      thana: json['thana'],
      district: json['district'],
      division: json['division'],
    );
  }
}

class AreaResponseModel {
  final int? statusCode;
  final List<AreaModel>? data;
  final int? responseTime;

  AreaResponseModel({
    this.statusCode,
    this.data,
    this.responseTime,
  });

  factory AreaResponseModel.fromJson(Map<String, dynamic> json) {
    return AreaResponseModel(
      statusCode: json['statusCode'],
      responseTime: json['responseTime'],
      data: json['data'] == null
          ? []
          : List<AreaModel>.from(
        json['data'].map((x) => AreaModel.fromJson(x)),
      ),
    );
  }
}

// Hello I am Tamim