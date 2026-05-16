class PatchLanguagesRequest {
  final List<String> languages;

  PatchLanguagesRequest({required this.languages});

  Map<String, dynamic> toJson() => {
    'languages': languages,
  };

  factory PatchLanguagesRequest.fromJson(Map<String, dynamic> json) => PatchLanguagesRequest(
    languages: List<String>.from(json['languages'] ?? []),
  );
}
// Hello I am Tamim