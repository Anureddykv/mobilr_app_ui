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
  factory BookModel.fromApi(Map<String, dynamic> json) {
  final ratingData = json['rating'];

  return BookModel(
    id: json['_id']?.toString() ??
        json['id']?.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString(),

    // ✅ Name / Title
    title: json['title']?.toString() ??
        json['name']?.toString() ??
        'Unknown Title',

    // ✅ Author
    author: json['author']?.toString() ??
        json['writer']?.toString() ??
        'Unknown Author',

    // ✅ Gallery Image Support
    imageUrl:
        (json['gallery'] is List &&
                (json['gallery'] as List).isNotEmpty)
            ? json['gallery'][0].toString()
            : json['imageUrl']?.toString() ??
                json['poster']?.toString() ??
                json['thumbnail']?.toString() ??
                'https://via.placeholder.com/200x300?text=No+Cover',

    // ✅ Rating Object Support
    rating: ratingData is Map
        ? (ratingData['star'] as num?)?.toDouble()
        : (ratingData as num?)?.toDouble(),

    // ✅ Votes Inside Rating
    votes: ratingData is Map
        ? ratingData['votes']?.toString()
        : json['votes']?.toString(),

    // ✅ Type → Genres
    genres: json['genres'] is List
        ? (json['genres'] as List)
            .map((e) => e.toString())
            .toList()
        : json['type'] != null
            ? [json['type'].toString()]
            : [],

    // ✅ Release Date
    releaseDate:
        json['releaseDate']?.toString() ??
        json['createdAt']?.toString(),

    // ✅ Description
    description:
        json['description']?.toString() ??
        "No description available.",
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
