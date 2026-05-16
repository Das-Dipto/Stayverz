class WorkUpdateModel {
  final String work;

  WorkUpdateModel({required this.work});

  factory WorkUpdateModel.fromJson(Map<String, dynamic> json) {
    return WorkUpdateModel(
      work: json['work'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'work': work,
    };
  }
}

// Hello I am Tamim