class PatchBioRequest {
  final String bio;

  PatchBioRequest({required this.bio});

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
    };
  }
}

// Hello I am Tamim