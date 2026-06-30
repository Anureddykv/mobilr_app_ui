class PreferenceEntity {
  final String title;
  final String description;
  final Map<String, List<String>> sections;

  PreferenceEntity({
    required this.title,
    required this.description,
    required this.sections,
  });

  // Factory constructor for parsing API responses in the future
  factory PreferenceEntity.fromJson(Map<String, dynamic> json) {
    return PreferenceEntity(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      sections: (json['sections'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, List<String>.from(value as List)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'sections': sections};
  }
}
