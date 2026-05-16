import 'package:get/get.dart';

/// Represents the typing status of a user in a conversation
class TypingStatusModel {
  final String userId;
  final String userName;
  final bool isTyping;
  final DateTime timestamp;

  TypingStatusModel({
    required this.userId,
    required this.userName,
    required this.isTyping,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory TypingStatusModel.fromJson(Map<String, dynamic> json) {
    return TypingStatusModel(
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      isTyping: json['is_typing'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'user_name': userName,
    'is_typing': isTyping,
    'timestamp': timestamp.toIso8601String(),
  };

  TypingStatusModel copyWith({
    String? userId,
    String? userName,
    bool? isTyping,
    DateTime? timestamp,
  }) {
    return TypingStatusModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      isTyping: isTyping ?? this.isTyping,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// A reactive version of TypingStatusModel that can be used with GetX
class RxTypingStatusModel extends GetxController {
  final Rx<TypingStatusModel> _typingStatus;

  RxTypingStatusModel(TypingStatusModel status) 
      : _typingStatus = status.obs;

  TypingStatusModel get value => _typingStatus.value;
  
  set value(TypingStatusModel status) => _typingStatus.value = status;
  
  Stream<TypingStatusModel> get stream => _typingStatus.stream;
  
  void updateStatus(bool isTyping) {
    _typingStatus.value = _typingStatus.value.copyWith(
      isTyping: isTyping,
      timestamp: DateTime.now(),
    );
  }
  
  @override
  void onClose() {
    _typingStatus.close();
    super.onClose();
  }
}

// Hello I am Tamim