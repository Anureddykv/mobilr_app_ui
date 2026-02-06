import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../review/MainReviewScreenBooks.dart';
import '../review/MainReviewScreenMovies.dart';
import '../review/MainReviewScreenGames.dart';
import '../review/MainReviewScreenGadgets.dart';
import '../review/MainReviewScreenRestaurants.dart';

const Color darkBackgroundColor = Color(0xFF0B0B0B);
const Color cardBackgroundColor = Color(0xFF141414);
const Color chipBackgroundColor = Color(0xFF1E1E1E);
const Color secondaryTextColor = Color(0xFF626365);
const Color faintTextColor = Color(0xFF3F3F3F);
const Color primaryTextColor = Colors.white;
const Color accentColor = Color(0xFF54B6E0);
const Color ratingBarBackgroundColor = Color(0xFF1E1E1E);


class SearchResult {
  final String id;
  final String title;
  final String imageUrl;
  final String subtitle1;
  final String subtitle2;
  final String subtitle3;
  final String description;
  final List<String> tags;
  final double rating;

  SearchResult({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.subtitle1,
    required this.subtitle2,
    required this.subtitle3,
    required this.description,
    this.tags = const [],
    this.rating = 0.0,
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
  bool _showFilters = false;
  bool _isAiSearchActive = false; // To track if AI search is triggered

  List<String> _selectedFilters = [];
  List<String> _relevantFilters = [
    "Action",
    "Thriller",
    "Suspense",
    "Chinese",
    "Adventure",
    "South Indian",
    "Self help",
    "Finance",
  ];
  // --- MOCK DATA ---
  final List<Map<String, String>> _mockRecentData = [
    {
      "url": "https://image.tmdb.org/t/p/w500/gKkl37BQuKTanygYQG1pyYgLVgf.jpg",
      "title": "Kalki 2898 AD"
    },
    {
      "url": "https://image.tmdb.org/t/p/w500/8Y4u2Qut2jI8t33fF2gIeG2xT5A.jpg",
      "title": "Salaar"
    },
    {
      "url": "https://image.tmdb.org/t/p/w500/r9oTE27Lptp0I1b5y2Q2I6L52iM.jpg",
      "title": "RRR"
    },
    {
      "url": "https://image.tmdb.org/t/p/w500/8b8R8l88Qje9dn9OE8Ya0GGW8iq.jpg",
      "title": "Dune: Part Two"
    },
  ];

  final List<String> _suggestions = [
    "Suggest me a Horror movie to watch on Netflix",
    "What are the trending Movies in Telugu.",
    "Anything Similar to Jungle Book",
  ];


  final List<SearchResult> _allSearchResults = [
    SearchResult(
      id: "movie_rrr",
      title: "RRR",
      imageUrl: "https://image.tmdb.org/t/p/w500/r9oTE27Lptp0I1b5y2Q2I6L52iM.jpg",
      subtitle1: "2h 58m",
      subtitle2: "U/A",
      subtitle3: "Telugu",
      description: "Oscar Winning Action Film",
      tags: ["Action", "South Indian", "Telugu", "Adventure"],
      rating: 0.8, // Corresponds to 4 stars
    ),
    SearchResult(
      id: "movie_kalki",
      title: "Kalki 2898 AD",
      imageUrl: "https://image.tmdb.org/t/p/w500/gKkl37BQuKTanygYQG1pyYgLVgf.jpg",
      subtitle1: "3h 1m",
      subtitle2: "U/A",
      subtitle3: "Sci-Fi",
      description: "A modern-day avatar of Vishnu",
      tags: ["Sci-Fi", "Action", "South Indian"],
      rating: 0.85, // Added rating
    ),
    SearchResult(
      id: "movie_dune2",
      title: "Dune: Part Two",
      imageUrl: "https://image.tmdb.org/t/p/w500/8b8R8l88Qje9dn9OE8Ya0GGW8iq.jpg",
      subtitle1: "2h 46m",
      subtitle2: "PG-13",
      subtitle3: "English",
      description: "Paul Atreides unites with Chani",
      tags: ["Sci-Fi", "Adventure", "English"],
      rating: 0.9, // Added rating
    ),
    SearchResult(
      id: "book_silent_patient",
      title: "The Silent Patient",
      imageUrl:
      "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1668783433l/40097951.jpg",
      subtitle1: "Book",
      subtitle2: "Psychological",
      subtitle3: "Thriller",
      description: "A shocking psychological thriller",
      tags: ["Thriller", "Suspense", "Novel"],
      rating: 0.88, // Added rating
    ),
  ];

  List<SearchResult> _filteredSearchResults = [];

  @override
  void initState() {
    super.initState();
    _filteredSearchResults = _allSearchResults;
    _searchController.addListener(_onSearchChanged);
    _fetchRecentSearches();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchQuery != _searchController.text) {
      setState(() {
        _searchQuery = _searchController.text;
        if (_isAiSearchActive) {
          _isAiSearchActive = false;
          _selectedFilters.clear();
        }
        _performSearch();
      });
    }
  }

  void _activateAiSearch() {
    if (_searchQuery.isNotEmpty && !_isAiSearchActive) {
      setState(() {
        _isAiSearchActive = true;
        _performSearch();
      });
    }
  }
  final GlobalKey _topRowKey = GlobalKey();
  double _topRowHeight = 40.0; // A sensible default height.

  // --- 2. Add this method to your _SearchScreenState ---
  void _updateTopRowHeight() {
    // This function runs after the frame is built, gets the height of the top row,
    // and rebuilds the widget if the height has changed.
    final keyContext = _topRowKey.currentContext;
    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      if (_topRowHeight != box.size.height) {
        setState(() {
          _topRowHeight = box.size.height;
        });
      }
    }
  }

  void _fetchRecentSearches() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  void _performSearch() {
    List<SearchResult> results;
    if (_searchQuery.isEmpty) {
      results = _isAiSearchActive ? [] : _allSearchResults;
    } else {
      results = _allSearchResults
          .where((r) =>
          r.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_selectedFilters.isNotEmpty) {
      results = results
          .where((r) => _selectedFilters.every((f) => r.tags.contains(f)))
          .toList();
    }

    setState(() {
      _filteredSearchResults = results;
      _relevantFilters = _allSearchResults
          .where((r) =>
          r.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .expand((r) => r.tags)
          .toSet()
          .toList()
        ..sort();
    });
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
      _performSearch();
    });
  }

  void _setSearchToSuggestion(String suggestion) {
    _searchController.text = suggestion;
    _activateAiSearch();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = "";
      _selectedFilters.clear();
      _showFilters = false;
      _isAiSearchActive = false;
      _filteredSearchResults = _allSearchResults;
    });
  }

  void _navigateToReviewScreen(SearchResult result) {
    Widget targetScreen;
    if (result.id.startsWith("movie_")) {
      targetScreen = MainReviewScreenMovies(movieId: result.id);
    } else if (result.id.startsWith("book_")) {
      targetScreen = MainReviewScreenBooks(bookId: result.id);
    } else if (result.id.startsWith("game_")) {
      targetScreen = MainReviewScreenGames(gameId: result.id);
    } else if (result.id.startsWith("gadget_")) {
      targetScreen = MainReviewScreenGadgets(gadgetId: result.id);
    } else if (result.id.startsWith("restaurant_")) {
      targetScreen = RestaurantReviewScreen(itemId: result.id);
    } else {
      // Default to movies if type unknown
      targetScreen = MainReviewScreenMovies(movieId: result.id);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }

  // ==========================
  // UI BUILD
  // ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: cardBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: _buildSearchBar(),
        toolbarHeight: 80,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_searchQuery.isEmpty) {
      return _buildDefaultSearchView();
    }
    if (_isAiSearchActive) {
      return _buildAiResultsView();
    }
    return _buildResultsView();
  }

  // ==========================
  // SEARCH BAR
  // ==========================
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      autofocus: false,
      style: const TextStyle(color: primaryTextColor, fontSize: 14),
      onSubmitted: (_) => _activateAiSearch(),
      decoration: InputDecoration(
        hintText: 'Ask Starnest AI anything...',
        hintStyle: const TextStyle(
            color: faintTextColor, fontSize: 14, fontWeight: FontWeight.w500,height: 0.72),
        prefixIcon: const Icon(Icons.search, color: faintTextColor, size: 22),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.close, color: secondaryTextColor, size: 20),
          onPressed: _clearSearch,
        )
            : null,
        filled: true,
        fillColor: cardBackgroundColor,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDefaultSearchView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        const Text('Suggestions',
            style: TextStyle(
                color: faintTextColor,
                fontSize: 12,
                fontFamily: 'General Sans Variable',
                fontWeight: FontWeight.w600,
                height: 0.72)),
        const SizedBox(height: 14),
        _buildSuggestionChips(),

        const SizedBox(height: 24),
        const Text('Recents',
            style: TextStyle(
                color: faintTextColor,
                fontSize: 12,
                fontFamily: 'General Sans Variable',
                fontWeight: FontWeight.w600,
                height: 0.72)),
        const SizedBox(height: 12),
        _isLoading ? _buildRecentsShimmer() : _buildRecentMovies(),
      ],
    );
  }

  Widget _buildResultsView() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _filteredSearchResults.length,
      separatorBuilder: (context, index) =>
      const Divider(color: cardBackgroundColor, height: 1),
      itemBuilder: (context, index) {
        final result = _filteredSearchResults[index];
        return _buildSearchResultItem(result, index + 1);
      },

    );
  }

  Widget _buildAiResultsView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
        // 1. User's Query Bubble
        _buildUserQueryBubble(),
        const SizedBox(height: 20),

        // 2. AI's Response Bubble
        _buildAiResponseCard(),
        const SizedBox(height: 20),

        // 3. Filter Section
        _buildFilterSection(),
        const SizedBox(height: 20),

        // 4. Divider
        const Divider(color: chipBackgroundColor, height: 1, thickness: 1),

        // 5. Results List
        if (_filteredSearchResults.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: Center(
                child: Text('No results for the selected filters.',
                    style:
                    TextStyle(color: secondaryTextColor, fontSize: 16))),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredSearchResults.length,
            separatorBuilder: (context, index) =>
            const Divider(color: chipBackgroundColor, height: 1),
            itemBuilder: (context, index) {
              final result = _filteredSearchResults[index];
              return _buildNumberedSearchResultItem(result, index + 1);
            },
          ),
      ],
    );
  }

  // ==========================
  // WIDGETS FOR AI RESULTS VIEW
  // ==========================
  Widget _buildUserQueryBubble() {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: const ShapeDecoration(
            color: cardBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(4),
              ),
            ),
          ),
          child: Text(
            _searchQuery,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'General Sans Variable',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAiResponseCard() {
    // This card mimics the AI response from Figma, including the detailed RRR card.
    final rrrResult = _allSearchResults.firstWhere((r) => r.id == "movie_rrr", orElse: () => _allSearchResults.first);

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.95),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: const ShapeDecoration(
            color: cardBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AI summary text
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14, height: 1.5, fontFamily: 'General Sans Variable'),
                  children: [
                    const TextSpan(
                      text: 'RRR',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(
                      text: ' is the only Indian Film to get that win an ',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    TextSpan(
                      text: 'Academy Award',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.8)),
                    ),
                    const TextSpan(
                      text: '.',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Divider
              const Divider(color: chipBackgroundColor, height: 1, thickness: 1),
              const SizedBox(height: 14),

              // Embedded RRR Movie Card
              _buildEmbeddedResultCard(rrrResult),
              const SizedBox(height: 14),

              // Detailed Description from Figma
              const Text(
                'In Salaar, a fierce warrior rises against a tyrannical regime to protect his friend and reclaim justice through violence. In Salaar, a fierce warrior rises against a tyrannical regime to protect his friend and reclaim justice through violence.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmbeddedResultCard(SearchResult result) {
    return GestureDetector(
      onTap: () => _navigateToReviewScreen(result),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: ShapeDecoration(
              image: DecorationImage(
                  image: NetworkImage(result.imageUrl), fit: BoxFit.cover),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: SizedBox(
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'General Sans Variable',
                          fontWeight: FontWeight.w600,
                            height: 0.72
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildSubtitleText(result.subtitle1),
                          _buildDotSeparator(),
                          _buildSubtitleText(result.subtitle2),
                          _buildDotSeparator(),
                          _buildSubtitleText(result.subtitle3),
                        ],
                      ),
                    ],
                  ),
                  _buildRatingBar(
                    displayValue: (result.rating * 5).toStringAsFixed(1),
                    progressValue: result.rating,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar({
    required String displayValue,
    required double progressValue,
  }) {
    final double ratingOutOfFive = progressValue * 5.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
          decoration: BoxDecoration(
            color: ratingBarBackgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayValue,
                style: const TextStyle(
                  color: primaryTextColor,
                  fontSize: 16,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w600,
                    height: 0.72
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  int fullStars = ratingOutOfFive.floor();
                  double fraction = ratingOutOfFive - fullStars;
                  Color filledStarColor = accentColor;
                  Color emptyStarColor = Colors.grey[700]!;

                  Widget star;
                  if (i < fullStars) {
                    star = Image.asset("assets/images/sd.png", width: 16, height: 16, color: filledStarColor);
                  } else if (i == fullStars && fraction >= 0.25) {
                    star = Stack(
                      children: [
                        Image.asset("assets/images/sd.png", width: 16, height: 16, color: emptyStarColor),
                        ClipRect(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            widthFactor: fraction,
                            child: Image.asset("assets/images/sd.png", width: 16, height: 16, color: filledStarColor),
                          ),
                        ),
                      ],
                    );
                  } else {
                    star = Image.asset("assets/images/sd.png", width: 16, height: 16, color: emptyStarColor);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: star,
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }



  Widget _buildFilterSection() {
    // This function will be called after the layout is complete
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateTopRowHeight());

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Layer 1: The animated list of all filters.
        // Its top padding is now DYNAMICALLY controlled by the height of the top row.
        Padding(
          padding: EdgeInsets.only(top: _topRowHeight),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SizeTransition(sizeFactor: animation, child: child, axisAlignment: -1.0);
            },
            child: _showFilters
                ? _buildAllFiltersList()
                : const SizedBox.shrink(),
          ),
        ),

        // Layer 2: The top row, which is always visible.
        _buildTopFilterRow(),
      ],
    );
  }

  Widget _buildTopFilterRow() {
    return Row(
      // We attach the GlobalKey here to measure this Row's height.
      key: _topRowKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container for the "Filters" button and its background.
        Container(
          decoration: BoxDecoration(
            color: _showFilters ? cardBackgroundColor : Colors.transparent,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(0, 10, 14, 10),
          child: GestureDetector(
            onTap: () => setState(() => _showFilters = !_showFilters),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: secondaryTextColor, width: 1.0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'General Sans Variable',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.40,
                        height: 0.72
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _showFilters ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ),
        // The selected items, which can cause this row to grow.
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _selectedFilters
                    .map((filter) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildFilterChip(
                        label: filter,
                        isSelected: true,
                        onTap: () => _toggleFilter(filter),
                      ),
                    ))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAllFiltersList() {
    return Container(
      key: const ValueKey('allFiltersBox'),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(14, 20, 14, 14), // Added extra top padding for visual separation
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: _relevantFilters
            .map((filter) => _buildFilterChip(
          label: filter,
          isSelected: _selectedFilters.contains(filter),
          onTap: () => _toggleFilter(filter),
        ))
            .toList(),
      ),
    );
  }



  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.15)
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: Colors.white.withOpacity(0.3), width: 1) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(Icons.close_rounded, color: Colors.white, size: 14),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontFamily: 'General Sans Variable',
                letterSpacing: 0.3,
                  height: 0.72
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildNumberedSearchResultItem(SearchResult result, int number) {
    return GestureDetector(
      onTap: () => _navigateToReviewScreen(result),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align to the top
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0), // Add padding to align with title
              child: Text(
                '$number.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w600,
                    height: 0.72
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 80, // Increased size to better match example
              height: 80,
              decoration: ShapeDecoration(
                image: DecorationImage(
                    image: NetworkImage(result.imageUrl), fit: BoxFit.cover),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Softer corners
              ),
            ),
            const SizedBox(width: 12),
            // Use Flexible to allow the column to take available space and prevent overflow
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
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
                  const SizedBox(height: 10),
                  Text(
                    result.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: secondaryTextColor, // Use secondary color for description
                      fontSize: 12,
                      fontFamily: 'General Sans Variable',
                      fontWeight: FontWeight.w500,
                        height: 0.72
                    ),
                  ),
                ],
              ),
            ),
            // Rating on the far right
            // Rating on the far right
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Add the star icon here
                Image.asset(
                  "assets/images/sd.png", // Make sure this path is correct
                  width: 16,
                  height: 16,
                  color: accentColor, // Use your accent color for the star
                ),
                const SizedBox(height: 6), // Spacing between star and number
                Text(
                  (result.rating * 5).toStringAsFixed(1), // Use actual rating data
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w600,
                      height: 0.72
                  ),
                ),
              ],
            )
      
          ],
        ),
      ),
    );
  }


  Widget _buildSearchResultItem(SearchResult result, int number) {
    return GestureDetector(
      onTap: () => _navigateToReviewScreen(result),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align to the top
          children: [
            // Number
            Padding(
              padding: const EdgeInsets.only(top: 4.0), // Add padding to align with title
              child: Text(
                '$number.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w600,
                    height: 0.72
                ),
              ),
            ),
            const SizedBox(width: 12),
      
            // Image
            Container(
              width: 80, // Match the size from the other widget
              height: 80,
              decoration: ShapeDecoration(
                image: DecorationImage(
                    image: NetworkImage(result.imageUrl), fit: BoxFit.cover),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Softer corners
              ),
            ),
            const SizedBox(width: 12),
      
            // Use Flexible for the main content column
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'General Sans Variable',
                        fontWeight: FontWeight.w600,
                        height: 0.72),
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
                  const SizedBox(height: 10),
                  Text(
                    result.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: secondaryTextColor, // Use secondary color
                      fontSize: 12,
                      fontFamily: 'General Sans Variable',
                      fontWeight: FontWeight.w500,
                        height: 0.72
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8), // Add spacing before the rating
      
            // Rating on the far right
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Star icon
                Image.asset(
                  "assets/images/sd.png", // Make sure this path is correct
                  width: 16,
                  height: 16,
                  color: accentColor, // Use your accent color
                ),
                const SizedBox(height: 6), // Spacing between star and number
                Text(
                  (result.rating * 5).toStringAsFixed(1), // Use actual rating data
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w600,
                      height: 0.72
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRecentMovies() {
    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _mockRecentData.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final movie = _mockRecentData[index];
          return GestureDetector(
            onTap: () => _setSearchToSuggestion(movie['title']!),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: ShapeDecoration(
                  image: DecorationImage(
                      image: NetworkImage(movie['url']!),
                      fit: BoxFit.cover),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuggestionChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _suggestions.map((suggestion) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: GestureDetector(
            onTap: () => _setSearchToSuggestion(suggestion),
            child: Chip(
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              labelPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              label: Text('“$suggestion”'),
              backgroundColor: chipBackgroundColor,
              labelStyle: const TextStyle(
                  color: faintTextColor,
                  fontSize: 12,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w500,
                  height: 1.1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              side: BorderSide.none,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentsShimmer() {
    return Shimmer.fromColors(
      baseColor: cardBackgroundColor,
      highlightColor: Colors.grey[850]!,
      child: SizedBox(
        height: 78,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) => AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitleText(String text) {
    return Text(text,
        style: const TextStyle(
            color: secondaryTextColor,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            fontFamily: 'General Sans Variable',
            letterSpacing: 0.5,height: 0.72));
  }

  Widget _buildDotSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: CircleAvatar(radius: 1.5, backgroundColor: secondaryTextColor),
    );
  }
}
