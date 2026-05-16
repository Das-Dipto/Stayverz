class PatchSchoolRequest {
  final String school;

  PatchSchoolRequest({required this.school});

  Map<String, dynamic> toJson() {
    return {
      'school': school,
    };
  }
}

// Hello I am Tamim