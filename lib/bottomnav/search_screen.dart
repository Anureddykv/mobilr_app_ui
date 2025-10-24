import 'package:flutter/material.dart';
import 'package:mobilr_app_ui/review/MainReviewScreenMovies.dart';
import 'package:shimmer/shimmer.dart';

// --- Re-using your app's color scheme for consistency ---
const Color darkBackgroundColor = Color(0xFF0B0B0B);
const Color cardBackgroundColor = Color(0xFF141414);
const Color secondaryTextColor = Color(0xFF626365);
const Color primaryTextColor = Colors.white;
const Color accentColor = Color(0xFF54B6E0); // Example accent color

// --- Mock Models for Search Results ---
class SearchResult {
  final String id;
  final String title;
  final String imageUrl;
  final String subtitle1;
  final String subtitle2;
  final String subtitle3;
  final String description;
  final List<String> tags;

  SearchResult({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.subtitle1,
    required this.subtitle2,
    required this.subtitle3,
    required this.description,
    this.tags = const [],
  });
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _isLoading = true;
  List<String> _recentSearches = [];

  // --- MODIFICATION 1: State variables for new filter logic ---
  List<String> _selectedFilters = []; // For multi-selection
  List<String> _relevantFilters = []; // For contextual filters

  final List<String> _mockRecentData = [
    "https://image.tmdb.org/t/p/w500/gKkl37BQuKTanygYQG1pyYgLVgf.jpg", // Kalki
    "https://image.tmdb.org/t/p/w500/8Y4u2Qut2jI8t33fF2gIeG2xT5A.jpg", // Oasis
    "https://image.tmdb.org/t/p/w500/r9oTE27Lptp0I1b5y2Q2I6L52iM.jpg", // RRR
    "https://image.tmdb.org/t/p/w500/8b8R8l88Qje9dn9OE8Ya0GGW8iq.jpg", // Dune
  ];

  // --- MODIFICATION 2: Updated search results with real image URLs ---
  final List<SearchResult> _allSearchResults = [
    SearchResult(id: "movie_rrr", title: "RRR", imageUrl: "https://image.tmdb.org/t/p/w500/r9oTE27Lptp0I1b5y2Q2I6L52iM.jpg", subtitle1: "2h 58m", subtitle2: "U/A", subtitle3: "Telugu", description: "Oscar Winning Action Film", tags: ["Action", "South Indian", "Telugu"]),
    SearchResult(id: "movie_kalki", title: "Kalki 2898 AD", imageUrl: "https://image.tmdb.org/t/p/w500/gKkl37BQuKTanygYQG1pyYgLVgf.jpg", subtitle1: "3h 1m", subtitle2: "U/A", subtitle3: "Sci-Fi", description: "A modern-day avatar of Vishnu", tags: ["Sci-Fi", "Action", "South Indian"]),
    SearchResult(id: "movie_dune2", title: "Dune: Part Two", imageUrl: "https://image.tmdb.org/t/p/w500/8b8R8l88Qje9dn9OE8Ya0GGW8iq.jpg", subtitle1: "2h 46m", subtitle2: "PG-13", subtitle3: "English", description: "Paul Atreides unites with Chani", tags: ["Sci-Fi", "Adventure", "English"]),
    SearchResult(id: "book_silent_patient", title: "The Silent Patient", imageUrl: "https://placehold.co/78x78/A9A9A9/000000?text=Book", subtitle1: "Book", subtitle2: "Psychological", subtitle3: "Thriller", description: "A shocking psychological thriller", tags: ["Thriller", "Suspense", "Self help"]),
  ];

  List<SearchResult> _filteredSearchResults = [];

  @override
  void initState() {
    super.initState();
    // Initially, show all results and derive filters from them
    _filteredSearchResults = _allSearchResults;
    _performSearch();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
        _performSearch();
      });
    });
    _fetchRecentSearches();
  }

  void _fetchRecentSearches() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _recentSearches = _mockRecentData;
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- MODIFICATION 3: Updated search logic ---
  void _performSearch() {
    List<SearchResult> results = _allSearchResults;

    // 1. Filter by search query first
    if (_searchQuery.isNotEmpty) {
      results = results.where((result) {
        return result.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // 2. Generate relevant filters from the current results
    // Using a Set removes duplicates automatically
    _relevantFilters = results
        .expand((result) => result.tags)
        .toSet()
        .toList()
      ..sort();

    // 3. Apply the multi-select filters
    if (_selectedFilters.isNotEmpty) {
      results = results.where((result) {
        // The item must have ALL of the selected filters
        return _selectedFilters.every((filter) => result.tags.contains(filter));
      }).toList();
    }

    setState(() {
      _filteredSearchResults = results;
    });
  }

  // --- MODIFICATION 4: Updated toggle logic for multi-select ---
  void _toggleFilter(String filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
      _performSearch(); // Re-run search with the updated filters
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: darkBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            // --- MODIFICATION 5: Condition to show results view ---
            // Show results view if search query is not empty OR if any filters are selected
            child: _searchQuery.isEmpty && _selectedFilters.isEmpty
                ? _buildDefaultSearchView()
                : _buildResultsView(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextField(
        controller: _searchController,
        autofocus: false,
        style: const TextStyle(
          color: primaryTextColor,
          fontSize: 16,
          fontFamily: 'General Sans Variable',
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
          hintText: 'Search Movies, Restaurants, Gadgets...',
          hintStyle: const TextStyle(
            color: secondaryTextColor,
            fontFamily: 'General Sans Variable',
          ),
          prefixIcon: const Icon(Icons.search, color: secondaryTextColor, size: 22),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.close, color: secondaryTextColor, size: 20),
            onPressed: () {
              // Also clear filters when clearing search text for a clean slate
              _searchController.clear();
              setState(() {
                _selectedFilters.clear();
              });
              _performSearch();
            },
          )
              : null,
          filled: true,
          fillColor: cardBackgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: accentColor, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentsShimmer() {
    return Shimmer.fromColors(
      baseColor: cardBackgroundColor,
      highlightColor: Colors.grey[800]!,
      child: SizedBox(
        height: 78,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            return AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDefaultSearchView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      children: [
        const Text(
          'Recents',
          style: TextStyle(
            color: secondaryTextColor,
            fontSize: 12,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        // --- FIX: Wrap with a Center widget ---
        Center(
          child: _isLoading
              ? _buildRecentsShimmer()
              : SizedBox(
            height: 78, // This height will now be correctly applied
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _recentSearches.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage(_recentSearches[index]),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // --- MODIFICATION 6: Results view updated to use new filter logic ---
  Widget _buildResultsView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      children: [
        const Text(
          'Filters',
          style: TextStyle(
            color: secondaryTextColor,
            fontSize: 12,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _relevantFilters.map((filter) {
            final bool isSelected = _selectedFilters.contains(filter);
            return _buildFilterChip(
              label: filter,
              isSelected: isSelected,
              onTap: () => _toggleFilter(filter),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Divider(color: cardBackgroundColor, height: 1),
        _filteredSearchResults.isEmpty
            ? const Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Center(
            child: Text(
              'No results found',
              style: TextStyle(color: secondaryTextColor, fontSize: 16),
            ),
          ),
        )
            : ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _filteredSearchResults.length,
          separatorBuilder: (context, index) => const Divider(color: cardBackgroundColor, height: 1),
          itemBuilder: (context, index) {
            final result = _filteredSearchResults[index];
            return GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MainReviewScreenMovies(movieId: result.id),
                  ),
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  children: [
                    Container(
                      width: 78,
                      height: 78,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(result.imageUrl),
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.title,
                            style: const TextStyle(
                              color: primaryTextColor,
                              fontSize: 16,
                              fontFamily: 'General Sans Variable',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _buildSubtitleText(result.subtitle1),
                              _buildDotSeparator(),
                              _buildSubtitleText(result.subtitle2),
                              _buildDotSeparator(),
                              _buildSubtitleText(result.subtitle3),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            result.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: secondaryTextColor,
                              fontSize: 14,
                              fontFamily: 'General Sans Variable',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : secondaryTextColor, // Changed for better visibility on accent color
          fontSize: 12,
          fontFamily: 'Product Sans',
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: isSelected ? accentColor.withOpacity(0.9) : const Color(0xFF1E1E1E),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
    );
  }

  Widget _buildSubtitleText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: secondaryTextColor,
        fontSize: 10,
        fontFamily: 'General Sans Variable',
        fontWeight: FontWeight.w600,
        letterSpacing: 0.50,
      ),
    );
  }

  Widget _buildDotSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: CircleAvatar(
        radius: 1.5,
        backgroundColor: secondaryTextColor,
      ),
    );
  }
}
