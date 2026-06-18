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
  final String? releaseDate;
  final String? description;

  MovieModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.votes,
    required this.language,
    required this.duration,
    required this.certification,
    required this.genres,
    this.releaseDate,
    this.description,
  });

  factory MovieModel.fromApi(Map<String, dynamic> json) {
    return MovieModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['bannerImage'] ?? '',
      rating: (json['rating']?['star'] ?? 0).toDouble(),
      votes: "${json['rating']?['votes'] ?? 0}",
      language: json['language'] ?? '',
      duration: json['duration'] ?? '',
      certification: json['certification'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      releaseDate: json['releaseDate'],
      description: json['synopsis'],
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
    required this.communities,
  });
}