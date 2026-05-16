class UpdateCohostAvailabilityRequest {
  final bool isAvailableForCohosting;

  UpdateCohostAvailabilityRequest({required this.isAvailableForCohosting});

  Map<String, dynamic> toJson() {
    return {
      'is_available_for_cohosting': isAvailableForCohosting,
    };
  }
}
class UpdateCohostAvailabilityResponse {
  final bool success;
  final int statusCode;
  final String message;
  final CohostAvailabilityData data;

  UpdateCohostAvailabilityResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory UpdateCohostAvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return UpdateCohostAvailabilityResponse(
      success: json['success'],
      statusCode: json['status_code'],
      message: json['message'],
      data: CohostAvailabilityData.fromJson(json['data']),
    );
  }
}

class CohostAvailabilityData {
  final bool isAvailableForCohosting;

  CohostAvailabilityData({required this.isAvailableForCohosting});

  factory CohostAvailabilityData.fromJson(Map<String, dynamic> json) {
    return CohostAvailabilityData(
      isAvailableForCohosting: json['is_available_for_cohosting'],
    );
  }
}

// Hello I am Tamim