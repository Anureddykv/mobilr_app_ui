import '../../domain/entities/search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../data_sources/search_local_data_source.dart';
import '../models/search_result_model.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchLocalDataSource localDataSource;

  SearchRepositoryImpl({required this.localDataSource});

  @override
  Future<List<SearchResult>> search(String query) async {
    final allResults = localDataSource.getAllResults();
    if (query.isEmpty) {
      return allResults.map((model) => model.toEntity()).toList();
    }
    return allResults
        .where((model) => model.title.toLowerCase().contains(query.toLowerCase()))
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<List<SearchResult>> searchWithFilters(String query, List<String> filters) async {
    final allResults = localDataSource.getAllResults();
    List<SearchResultModel> filteredResults = allResults;

    if (query.isNotEmpty) {
      filteredResults = filteredResults
          .where((model) => model.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    if (filters.isNotEmpty) {
      filteredResults = filteredResults
          .where((model) => filters.every((f) => model.tags.contains(f)))
          .toList();
    }

    return filteredResults.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<String>> getRecentSearches() async {
    return localDataSource.getRecentSearches();
  }

  @override
  Future<void> saveRecentSearch(String query) async {
    await localDataSource.saveRecentSearch(query);
  }
}
