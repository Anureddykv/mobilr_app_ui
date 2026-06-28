class SearchResult {
  final String id;
  final String title;
  final String imageUrl;
  final String subtitle1;
  final String subtitle2;
  final String subtitle3;
  final String description;
  final List<String> tags;
  final double rating;

  SearchResult({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.subtitle1,
    required this.subtitle2,
    required this.subtitle3,
    required this.description,
    this.tags = const [],
    this.rating = 0.0,
  });

  SearchResult copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? subtitle1,
    String? subtitle2,
    String? subtitle3,
    String? description,
    List<String>? tags,
    double? rating,
  }) {
    return SearchResult(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      subtitle1: subtitle1 ?? this.subtitle1,
      subtitle2: subtitle2 ?? this.subtitle2,
      subtitle3: subtitle3 ?? this.subtitle3,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
    );
  }
}
