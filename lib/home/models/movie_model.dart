// lib/home/models/movie_model.dart

class MovieModel {
  final String id;
  final String title;
  final String imageUrl;
  final double rating;
  final String votes;
  final String language;
  final String duration;
  final String certification;
  final List<String> genres;
  final String? releaseDate; // For upcoming movies
  final String? description; // Optional

  MovieModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.votes,
    required this.language,
    required this.duration,
    required this.certification,required this.genres,
    this.releaseDate,
    this.description,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? 'Unknown Title',
      imageUrl: json['imageUrl'] as String? ?? 'https://via.placeholder.com/200x300?text=No+Image',
      rating: (json['rating'] as num? ?? 0.0).toDouble(),
      votes: (json['votes'] as String? ?? "0"),
      language: json['language'] as String? ?? 'N/A',
      duration: json['duration'] as String? ?? 'N/A',
      certification: json['certification'] as String? ?? 'N/A',
      genres: List<String>.from(json['genres'] as List? ?? []),
      releaseDate: json['releaseDate'] as String?,
      description: json['description'] as String?,
    );
  }
}

class MovieDataModel {
  final List<MovieModel> featured;
  final List<MovieModel> trending;
  final List<MovieModel> upcoming;
  final List<MovieModel> communities;
  MovieDataModel({
    required this.featured,
    required this.trending,
    required this.upcoming,
    required this.communities, // <-- ADDED
  });

  factory MovieDataModel.fromJson(Map<String, dynamic> json) {
    return MovieDataModel(
      featured: (json['featured'] as List<dynamic>? ?? [])
          .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      trending: (json['trending'] as List<dynamic>? ?? [])
          .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      upcoming: (json['upcoming'] as List<dynamic>? ?? [])
          .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      communities: (json['communities'] as List<dynamic>? ?? []) // <-- ADDED
          .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
