import '../entities/search_result.dart';
import '../repositories/search_repository.dart';

class Search {
  final SearchRepository repository;

  Search(this.repository);

  Future<List<SearchResult>> call(String query) {
    return repository.search(query);
  }
}
