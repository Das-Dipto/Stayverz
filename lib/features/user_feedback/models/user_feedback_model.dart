class UserFeedbackModel {
  final int rating;
  final String category;
  final String feedback;
  final DateTime createdAt;
  final String? userId;
  final String? userType;

  UserFeedbackModel({
    required this.rating,
    required this.category,
    required this.feedback,
    required this.createdAt,
    this.userId,
    this.userType,
  });

  factory UserFeedbackModel.fromJson(Map<String, dynamic> json) {
    return UserFeedbackModel(
      rating: json['rating'] ?? 0,
      category: json['category'] ?? '',
      feedback: json['feedback'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      userId: json['user_id'],
      userType: json['user_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'category': category,
      'feedback': feedback,
      'created_at': createdAt.toIso8601String(),
      if (userId != null) 'user_id': userId,
      if (userType != null) 'user_type': userType,
    };
  }

  UserFeedbackModel copyWith({
    int? rating,
    String? category,
    String? feedback,
    DateTime? createdAt,
    String? userId,
    String? userType,
  }) {
    return UserFeedbackModel(
      rating: rating ?? this.rating,
      category: category ?? this.category,
      feedback: feedback ?? this.feedback,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      userType: userType ?? this.userType,
    );
  }

  @override
  String toString() {
    return 'UserFeedbackModel(rating: $rating, category: $category, feedback: $feedback, createdAt: $createdAt, userId: $userId, userType: $userType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is UserFeedbackModel &&
      other.rating == rating &&
      other.category == category &&
      other.feedback == feedback &&
      other.createdAt == createdAt &&
      other.userId == userId &&
      other.userType == userType;
  }

  @override
  int get hashCode {
    return rating.hashCode ^
      category.hashCode ^
      feedback.hashCode ^
      createdAt.hashCode ^
      userId.hashCode ^
      userType.hashCode;
  }
}

// Hello I am Tamim