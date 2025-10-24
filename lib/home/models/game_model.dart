// lib/home/models/game_model.dart

class GameModel {
  final String id;
  final String title;
  final String developer;
  final String imageUrl;
  final double? rating;
  final String? votes;
  final List<String> genres;
  final List<String> platforms;
  final String? releaseDate;
  final String? description;

  GameModel({
    required this.id,
    required this.title,
    required this.developer,
    required this.imageUrl,
    this.rating,
    this.votes,
    required this.genres,
    required this.platforms,
    this.releaseDate,
    this.description,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? 'Unknown Title',
      developer: json['developer'] as String? ?? 'Unknown Developer',
      imageUrl: json['imageUrl'] as String? ?? 'https://via.placeholder.com/200x300?text=No+Art',
      rating: (json['rating'] as num?)?.toDouble(),
      votes: json['votes'] as String?,
      genres: List<String>.from(json['genres'] as List? ?? []),
      platforms: List<String>.from(json['platforms'] as List? ?? []),
      releaseDate: json['releaseDate'] as String?,
      description: json['description'] as String?,
    );
  }
}

class GameDataModel {
  final List<GameModel> featured;
  final List<GameModel> trending;
  final List<GameModel> upcoming;
  final List<GameModel> communities;
  final List<GameModel> discordServers;

  GameDataModel({
    required this.featured,
    required this.trending,
    required this.upcoming,
    required this.communities,
    required this.discordServers,
  });

  factory GameDataModel.fromJson(Map<String, dynamic> json) {
    List<GameModel> _parseList(String key) {
      return (json[key] as List<dynamic>? ?? [])
          .map((item) => GameModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return GameDataModel(
      featured: _parseList('featured'),
      trending: _parseList('trending'),
      upcoming: _parseList('upcoming'),
      communities: _parseList('communities'),
      discordServers: _parseList('discordServers'),
    );
  }
}
