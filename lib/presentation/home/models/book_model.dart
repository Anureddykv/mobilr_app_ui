// lib/home/models/book_model.dart

class BookModel {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final double? rating;
  final String? votes;
  final List<String> genres;
  final String? releaseDate;
  final String? description;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    this.rating,
    this.votes,
    required this.genres,
    this.releaseDate,
    this.description,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? 'Unknown Title',
      author: json['author'] as String? ?? 'Unknown Author',
      imageUrl: json['imageUrl'] as String? ?? 'https://via.placeholder.com/200x300?text=No+Cover',
      rating: (json['rating'] as num?)?.toDouble(),
      votes: json['votes'] as String?,
      genres: List<String>.from(json['genres'] as List? ?? []),
      releaseDate: json['releaseDate'] as String?,
      description: json['description'] as String?,
    );
  }
}

class BookDataModel {
  final List<BookModel> featured;
  final List<BookModel> trending;
  final List<BookModel> upcoming;
  final List<BookModel> communities;

  BookDataModel({
    required this.featured,
    required this.trending,
    required this.upcoming,
    required this.communities,
  });

  factory BookDataModel.fromJson(Map<String, dynamic> json) {
    List<BookModel> _parseList(String key) {
      return (json[key] as List<dynamic>? ?? [])
          .map((item) => BookModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return BookDataModel(
      featured: _parseList('featured'),
      trending: _parseList('trending'),
      upcoming: _parseList('upcoming'),
      communities: _parseList('communities'),
    );
  }
}
