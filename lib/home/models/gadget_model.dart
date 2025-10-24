// lib/home/models/gadget_model.dart

class GadgetModel {
  final String id;
  final String name;
  final String brand;
  final String imageUrl;
  final double? rating;
  final String? votes;
  final List<String> keyFeatures;  final String? releaseDate;
  final String? description;

  GadgetModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageUrl,
    this.rating,
    this.votes,
    required this.keyFeatures,
    this.releaseDate,
    this.description,
  });

  factory GadgetModel.fromJson(Map<String, dynamic> json) {
    return GadgetModel(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] as String? ?? 'Unknown Gadget',
      brand: json['brand'] as String? ?? 'Unknown Brand',
      imageUrl: json['imageUrl'] as String? ?? 'https://via.placeholder.com/200x300?text=No+Image',
      rating: (json['rating'] as num?)?.toDouble(),
      votes: json['votes'] as String?,
      keyFeatures: List<String>.from(json['keyFeatures'] as List? ?? []),
      releaseDate: json['releaseDate'] as String?,
      description: json['description'] as String?,
    );
  }
}

class GadgetDataModel {
  final List<GadgetModel> featured;
  final List<GadgetModel> trending;
  final List<GadgetModel> upcoming;
  final List<GadgetModel> communities;

  GadgetDataModel({
    required this.featured,
    required this.trending,
    required this.upcoming,
    required this.communities,
  });

  factory GadgetDataModel.fromJson(Map<String, dynamic> json) {
    // Helper to prevent repetition
    List<GadgetModel> _parseList(String key) {
      return (json[key] as List<dynamic>? ?? [])
          .map((item) => GadgetModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return GadgetDataModel(
      featured: _parseList('featured'),
      trending: _parseList('trending'),
      upcoming: _parseList('upcoming'),
      communities: _parseList('communities'),
    );
  }
}
