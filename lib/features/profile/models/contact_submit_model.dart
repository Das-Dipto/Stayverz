class ContactUser {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String text;

  ContactUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.text,
  });

  // Convert JSON to Dart object
  factory ContactUser.fromJson(Map<String, dynamic> json) {
    return ContactUser(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      text: json['text'],
    );
  }

  // Convert Dart object to JSON
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'text': text,
    };
  }
}

// Hello I am Tamim