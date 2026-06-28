import 'package:get/get.dart';
import 'package:starnest/features/search/domain/entities/search_result.dart';
import 'package:starnest/features/search/domain/usecases/search.dart';
import 'package:starnest/features/search/domain/usecases/search_with_filters.dart';
import 'package:starnest/features/search/data/data_sources/search_local_data_source.dart';
import 'package:starnest/features/search/data/repositories_impl/search_repository_impl.dart';

class SearchResultsController extends GetxController {
  final RxList<SearchResult> searchResults = <SearchResult>[].obs;
  final RxList<SearchResult> filteredResults = <SearchResult>[].obs;
  final RxList<String> selectedFilters = <String>[].obs;
  final RxList<String> relevantFilters = <String>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isAiSearchActive = false.obs;
  final RxBool isLoading = true.obs;

  late final Search searchUseCase;
  late final SearchWithFilters searchWithFiltersUseCase;

  @override
  void onInit() {
    super.onInit();

    // Initialize dependencies
    final localDataSource = SearchLocalDataSourceImpl();
    final repository = SearchRepositoryImpl(localDataSource: localDataSource);
    searchUseCase = Search(repository);
    searchWithFiltersUseCase = SearchWithFilters(repository);

    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final results = await searchUseCase('');
      searchResults.value = results;
      filteredResults.value = results;

      // Set default relevant filters
      relevantFilters.value = [
        "Action",
        "Thriller",
        "Suspense",
        "Chinese",
        "Adventure",
        "South Indian",
        "Self help",
        "Finance",
      ];

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<void> performSearch(String query) async {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredResults.value = searchResults;
      isAiSearchActive.value = false;
      selectedFilters.clear();
      return;
    }

    if (selectedFilters.isEmpty) {
      final results = await searchUseCase(query);
      filteredResults.value = results;
    } else {
      final results = await searchWithFiltersUseCase(query, selectedFilters);
      filteredResults.value = results;
    }

    // Update relevant filters based on search
    _updateRelevantFilters(query);
  }

  void _updateRelevantFilters(String query) {
    if (query.isEmpty) {
      relevantFilters.value = [
        "Action",
        "Thriller",
        "Suspense",
        "Chinese",
        "Adventure",
        "South Indian",
        "Self help",
        "Finance",
      ];
      return;
    }

    final matchingTags = searchResults
        .where((r) => r.title.toLowerCase().contains(query.toLowerCase()))
        .expand((r) => r.tags)
        .toSet()
        .toList();

    relevantFilters.value = matchingTags..sort();
  }

  void toggleFilter(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }

    performSearch(searchQuery.value);
  }

  void activateAiSearch() {
    if (searchQuery.value.isNotEmpty && !isAiSearchActive.value) {
      isAiSearchActive.value = true;
      selectedFilters.clear();
      performSearch(searchQuery.value);
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    selectedFilters.clear();
    isAiSearchActive.value = false;
    filteredResults.value = searchResults;
  }
}
