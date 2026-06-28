import '../../domain/entities/search_result.dart';

class SearchResultModel extends SearchResult {
  SearchResultModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    required super.subtitle1,
    required super.subtitle2,
    required super.subtitle3,
    required super.description,
    super.tags = const [],
    super.rating = 0.0,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      subtitle1: json['subtitle1'] ?? '',
      subtitle2: json['subtitle2'] ?? '',
      subtitle3: json['subtitle3'] ?? '',
      description: json['description'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'subtitle1': subtitle1,
      'subtitle2': subtitle2,
      'subtitle3': subtitle3,
      'description': description,
      'tags': tags,
      'rating': rating,
    };
  }

  SearchResult toEntity() {
    return SearchResult(
      id: id,
      title: title,
      imageUrl: imageUrl,
      subtitle1: subtitle1,
      subtitle2: subtitle2,
      subtitle3: subtitle3,
      description: description,
      tags: tags,
      rating: rating,
    );
  }

  factory SearchResultModel.fromEntity(SearchResult entity) {
    return SearchResultModel(
      id: entity.id,
      title: entity.title,
      imageUrl: entity.imageUrl,
      subtitle1: entity.subtitle1,
      subtitle2: entity.subtitle2,
      subtitle3: entity.subtitle3,
      description: entity.description,
      tags: entity.tags,
      rating: entity.rating,
    );
  }
}
