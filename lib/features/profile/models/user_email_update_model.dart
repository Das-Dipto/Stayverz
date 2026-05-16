class UserEmailUpdateRequest {
  final String email;
  final String scope;

  UserEmailUpdateRequest({
    required this.email,
    required this.scope,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'scope': scope,
    };
  }
}

// Hello I am Tamim