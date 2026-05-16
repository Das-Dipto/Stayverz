class UserModel {
  final String accessToken;
  final String refreshToken;
  final String userType;

  UserModel({
    required this.accessToken,
    required this.refreshToken,
    required this.userType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      userType: json['user_type'] ?? 'guest',
    );
  }
}


// Hello I am Tamim