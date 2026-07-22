class RunsysStatusModel {
  final bool success;
  final String message;
  final String? status; // approved, pending, rejected, or null (not requested)
  final String? companyName;
  final String? email;
  final String? phoneNumber;
  final String? rejectionReason;
  final String? requestedAt;
  final String? approvedAt;
  final String? rejectedAt;

  RunsysStatusModel({
    required this.success,
    required this.message,
    this.status,
    this.companyName,
    this.email,
    this.phoneNumber,
    this.rejectionReason,
    this.requestedAt,
    this.approvedAt,
    this.rejectedAt,
  });

  bool get isApproved => (status ?? '').toLowerCase() == 'approved';
  bool get isPending => (status ?? '').toLowerCase() == 'pending';
  bool get isRejected => (status ?? '').toLowerCase() == 'rejected';
  bool get hasRequested => status != null && status!.isNotEmpty;

  factory RunsysStatusModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return RunsysStatusModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      status: data?['status'] as String?,
      companyName: data?['company_name'] as String?,
      email: data?['email'] as String?,
      phoneNumber: data?['phone_number'] as String?,
      rejectionReason: data?['rejection_reason'] as String?,
      requestedAt: data?['requested_at'] as String?,
      approvedAt: data?['approved_at'] as String?,
      rejectedAt: data?['rejected_at'] as String?,
    );
  }
}

// Hello I am Tamim