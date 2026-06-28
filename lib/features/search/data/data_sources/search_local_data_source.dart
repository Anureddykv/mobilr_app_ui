import '../models/search_result_model.dart';

abstract class SearchLocalDataSource {
  List<SearchResultModel> getAllResults();
  Future<List<String>> getRecentSearches();
  Future<void> saveRecentSearch(String query);
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final List<String> _recentSearches = [];

  @override
  List<SearchResultModel> getAllResults() {
    // This would typically read from API or local database
    // For now, returning mock data
    return [
      SearchResultModel(
        id: "movie_rrr",
        title: "RRR",
        imageUrl: "https://image.tmdb.org/t/p/w500/r9oTE27Lptp0I1b5y2Q2I6L52iM.jpg",
        subtitle1: "2h 58m",
        subtitle2: "U/A",
        subtitle3: "Telugu",
        description: "Oscar Winning Action Film",
        tags: ["Action", "South Indian", "Telugu", "Adventure"],
        rating: 0.8,
      ),
      SearchResultModel(
        id: "movie_kalki",
        title: "Kalki 2898 AD",
        imageUrl: "https://image.tmdb.org/t/p/w500/gKkl37BQuKTanygYQG1pyYgLVgf.jpg",
        subtitle1: "3h 1m",
        subtitle2: "U/A",
        subtitle3: "Sci-Fi",
        description: "A modern-day avatar of Vishnu",
        tags: ["Sci-Fi", "Action", "South Indian"],
        rating: 0.85,
      ),
      SearchResultModel(
        id: "movie_dune2",
        title: "Dune: Part Two",
        imageUrl: "https://image.tmdb.org/t/p/w500/8b8R8l88Qje9dn9OE8Ya0GGW8iq.jpg",
        subtitle1: "2h 46m",
        subtitle2: "PG-13",
        subtitle3: "English",
        description: "Paul Atreides unites with Chani",
        tags: ["Sci-Fi", "Adventure", "English"],
        rating: 0.9,
      ),
      SearchResultModel(
        id: "book_silent_patient",
        title: "The Silent Patient",
        imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1668783433l/40097951.jpg",
        subtitle1: "Book",
        subtitle2: "Psychological",
        subtitle3: "Thriller",
        description: "A shocking psychological thriller",
        tags: ["Thriller", "Suspense", "Novel"],
        rating: 0.88,
      ),
    ];
  }

  @override
  Future<List<String>> getRecentSearches() async {
    // This would typically read from SharedPreferences
    return _recentSearches;
  }

  @override
  Future<void> saveRecentSearch(String query) async {
    if (!_recentSearches.contains(query)) {
      _recentSearches.add(query);
    }
    // This would typically save to SharedPreferences
  }
}
