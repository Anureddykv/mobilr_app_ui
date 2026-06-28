import '../entities/search_result.dart';
import '../repositories/search_repository.dart';

class SearchWithFilters {
  final SearchRepository repository;

  SearchWithFilters(this.repository);

  Future<List<SearchResult>> call(String query, List<String> filters) {
    return repository.searchWithFilters(query, filters);
  }
}
