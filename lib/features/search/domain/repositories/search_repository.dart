import '../entities/search_result.dart';

abstract class SearchRepository {
  Future<List<SearchResult>> search(String query);
  Future<List<SearchResult>> searchWithFilters(String query, List<String> filters);
  Future<List<String>> getRecentSearches();
  Future<void> saveRecentSearch(String query);
}
