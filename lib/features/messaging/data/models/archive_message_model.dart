class ArchiveChatResponse {
  final bool success;
  final String message;
  final String roomId;

  ArchiveChatResponse({
    required this.success,
    required this.message,
    required this.roomId,
  });

  factory ArchiveChatResponse.fromJson(Map<String, dynamic> json) {
    return ArchiveChatResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      roomId: json['room_id'] ?? '',
    );
  }
}

// Hello I am Tamim