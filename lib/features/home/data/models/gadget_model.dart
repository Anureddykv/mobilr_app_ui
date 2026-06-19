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
  factory GadgetModel.fromApi(Map<String, dynamic> json) {
  final ratingData = json['rating'];
  final specsData = json['specs'];

  return GadgetModel(
    id: json['_id']?.toString() ??
        json['id']?.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString(),

    name: json['name']?.toString() ??
        json['title']?.toString() ??
        'Unknown Gadget',

    // ✅ Better Brand/Type Handling
    brand: json['brand']?.toString() ??
        json['company']?.toString() ??
        json['type']?.toString() ??
        'Unknown Brand',

    // ✅ Better Image Handling
    imageUrl:
        (json['gallery'] is List &&
                (json['gallery'] as List).isNotEmpty)
            ? json['gallery'][0].toString()
            : json['imageUrl']?.toString() ??
                json['poster']?.toString() ??
                json['thumbnail']?.toString() ??
                'https://via.placeholder.com/200x300?text=No+Image',

    // ✅ Safe Rating Parsing
    rating: ratingData is Map
        ? (ratingData['star'] as num?)?.toDouble()
        : (ratingData as num?)?.toDouble(),

    // ✅ Safe Votes Parsing
    votes: ratingData is Map
        ? ratingData['votes']?.toString()
        : null,

    // ✅ Specs → Feature List
    keyFeatures: specsData is Map<String, dynamic>
        ? specsData.entries
            .map((e) => "${e.key}: ${e.value}")
            .toList()
        : [],

    // ✅ Release Date
    releaseDate:
        json['createdAt']?.toString() ??
        json['releaseDate']?.toString(),

    // ✅ Description
    description:
        json['description']?.toString() ??
        "No description available.",
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
