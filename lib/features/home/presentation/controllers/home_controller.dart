import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:starnest/core/api_service.dart';
import 'package:starnest/core/tracking/starnest_tracker.dart';

import '../../data/models/movie_model.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/models/gadget_model.dart';
import '../../data/models/book_model.dart';
import '../../data/models/game_model.dart';

// Accent Colors
const Color movieAccentColor = Color(0xFF54B6E0); // From HomeScreen
const Color restaurantAccentColor = Color(0xFFF9C74F);
const Color gadgetAccentColor = Color(0xFFE45659);
const Color bookAccentColor = Color(0xFFCDBBE9);
const Color gameAccentColor = Color(0xFF90BE6D);
const Color defaultAccentColor = Colors.teal; // Fallback

// ✅ Color constants for the new snackbars
const Color snackbarBackgroundColor = Color(0xFF141414);
const Color snackbarSuccessColor = Color(0xFF9DD870);
const Color snackbarWarningColor = Colors.orange;
const Color snackbarInfoColor = Color(0xFF54B6E0);
const Color snackbarNeutralColor = Color(0xFF626365);

class HomeController extends GetxController {
  var selectedCategory = "Movies".obs;
  var categories = <String>[
    'Movies',
    'Restaurants',
    'Gadgets',
    'Books',
    'Games',
  ].obs;
  var currentAccentColor =
      movieAccentColor.obs; // Initialize with default for "Movies"

  final Rx<String?> _viewingMovieId = Rx<String?>(null);
  String? get viewingMovieId => _viewingMovieId.value;

  // --- NEW: Method to show the review screen for a specific movie ---
  void showMovieReviews(String movieId) {
    _viewingMovieId.value = movieId;
  }

  // --- NEW: Method to go back to the main tab view ---
  void closeMovieReviews() {
    _viewingMovieId.value = null;
  }

  final RxSet<String> savedItemIds = <String>{}.obs;

  // 2. A generic method to check if any item is saved.
  bool isItemSaved(String itemId) {
    return savedItemIds.contains(itemId);
  }

  // This method is already correct from our previous conversation
  void toggleItemSaved(String itemId, {String itemName = 'Item'}) {
    final String itemDisplayName = itemName.length > 20
        ? '${itemName.substring(0, 20)}...'
        : itemName;

    if (isItemSaved(itemId)) {
      savedItemIds.remove(itemId);
      StarNestTracker.instance.trackBookmarkRemove(
        module: selectedCategory.value.toLowerCase(),
        itemId: itemId,
      );
      print("$itemName with ID $itemId unsaved.");

      // Show the "Removed" custom snackbar with neutral colors
      Get.showSnackbar(
        GetSnackBar(
          messageText: const _CustomSnackbarWidget(
            message: 'Removed from your list.',
            backgroundColor: snackbarBackgroundColor,
            icon: Icons.remove,
            iconColor: snackbarNeutralColor,
            textColor: snackbarNeutralColor,
          ),
          backgroundColor: Colors.transparent,
          duration: const Duration(seconds: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );
    } else {
      savedItemIds.add(itemId);
      StarNestTracker.instance.trackBookmarkAdd(
        module: selectedCategory.value.toLowerCase(),
        itemId: itemId,
      );
      print("$itemName with ID $itemId saved.");

      // Show the "Added" custom snackbar with dynamic accent colors
      Get.showSnackbar(
        GetSnackBar(
          messageText: _CustomSnackbarWidget(
            message: '$itemDisplayName added to your list!',
            backgroundColor: snackbarBackgroundColor,
            icon: Icons.check,
            iconColor: currentAccentColor.value,
            textColor: currentAccentColor.value,
          ),
          backgroundColor: Colors.transparent,
          duration: const Duration(seconds: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );
    }
  }

  var movieData = MovieDataModel(
    featured: [],
    trending: [],
    upcoming: [],
    communities: [],
  ).obs;
  var isLoadingMovies = true.obs;
  final RxSet<String> notifiedUpcomingMovies = <String>{}.obs;
  var restaurantData = RestaurantDataModel(
    featured: [],
    trending: [],
    upcoming: [],
    communities: [],
  ).obs;
  var isLoadingRestaurants = true.obs;
  final RxBool hasLoadedMovies = false.obs;
  final RxBool hasLoadedRestaurants = false.obs;
  final RxBool hasLoadedGadgets = false.obs;
  final RxBool hasLoadedBooks = false.obs;
  final RxBool hasLoadedGames = false.obs;

  var gadgetData = GadgetDataModel(
    featured: [],
    trending: [],
    upcoming: [],
    communities: [],
  ).obs;
  var isLoadingGadgets = true.obs;

  var bookData = BookDataModel(
    featured: [],
    trending: [],
    upcoming: [],
    communities: [],
  ).obs;
  var isLoadingBooks = true.obs;

  var gameData = GameDataModel(
    featured: [],
    trending: [],
    upcoming: [],
    communities: [],
    discordServers: [],
  ).obs;
  var isLoadingGames = true.obs;

  var selectedBottomNavIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _updateAccentColor(selectedCategory.value);
    fetchMovieData();
  }

  final RxString selectedSurveyOption =
      "".obs; // Holds the currently selected option
  final RxBool hasSubmittedSurvey =
      false.obs; // Tracks if the survey has been submitted

  void selectSurveyOption(String option) {
    if (!hasSubmittedSurvey.value) {
      // Only allow selection if not already submitted
      selectedSurveyOption.value = option;
    }
  }

  // ✅ UPDATED: submitSurvey now uses the custom snackbar
  void submitSurvey() {
    if (selectedSurveyOption.value.isNotEmpty && !hasSubmittedSurvey.value) {
      print("Survey Submitted: ${selectedSurveyOption.value}");
      hasSubmittedSurvey.value = true;

      Get.showSnackbar(
        GetSnackBar(
          messageText: _CustomSnackbarWidget(
            message: "You selected: ${selectedSurveyOption.value}",
            backgroundColor: snackbarBackgroundColor,
            icon: Icons.check,
            iconColor: currentAccentColor.value,
            textColor: currentAccentColor.value,
          ),
          backgroundColor: Colors.transparent,
          duration: const Duration(seconds: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );
    } else if (hasSubmittedSurvey.value) {
      Get.showSnackbar(
        GetSnackBar(
          messageText: const _CustomSnackbarWidget(
            message: "You have already submitted your response.",
            backgroundColor: snackbarBackgroundColor,
            icon: Icons.info_outline,
            iconColor: snackbarInfoColor,
            textColor: snackbarInfoColor,
          ),
          backgroundColor: Colors.transparent,
          duration: const Duration(seconds: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );
    } else {
      Get.showSnackbar(
        GetSnackBar(
          messageText: const _CustomSnackbarWidget(
            message: "Please select an option before submitting.",
            backgroundColor: snackbarBackgroundColor,
            icon: Icons.warning_amber_rounded,
            iconColor: snackbarWarningColor,
            textColor: snackbarWarningColor,
          ),
          backgroundColor: Colors.transparent,
          duration: const Duration(seconds: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );
    }
  }

  void resetSurveyState() {
    selectedSurveyOption.value = "";
    hasSubmittedSurvey.value = false;
  }

  // ✅ UPDATED: toggleUpcomingMovieNotification now uses the custom snackbar
  void toggleUpcomingMovieNotification(String movieIdOrTitle) {
    if (notifiedUpcomingMovies.contains(movieIdOrTitle)) {
      notifiedUpcomingMovies.remove(movieIdOrTitle);
      StarNestTracker.instance.trackNotifyDisable(
        module: selectedCategory.value.toLowerCase(),
        itemId: movieIdOrTitle,
      );
      print("Notifications OFF for: $movieIdOrTitle");

      Get.showSnackbar(
        GetSnackBar(
          messageText: _CustomSnackbarWidget(
            message: "No more notifications for $movieIdOrTitle.",
            backgroundColor: snackbarBackgroundColor,
            icon: Icons.notifications_off_outlined,
            iconColor: snackbarNeutralColor,
            textColor: snackbarNeutralColor,
          ),
          backgroundColor: Colors.transparent,
          duration: const Duration(seconds: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );
    } else {
      notifiedUpcomingMovies.add(movieIdOrTitle);
      StarNestTracker.instance.trackNotifyEnable(
        module: selectedCategory.value.toLowerCase(),
        itemId: movieIdOrTitle,
      );
      print("Notifications ON for: $movieIdOrTitle");

      Get.showSnackbar(
        GetSnackBar(
          messageText: _CustomSnackbarWidget(
            message: "We'll notify you about $movieIdOrTitle!",
            backgroundColor: snackbarBackgroundColor,
            icon: Icons.notifications_active_outlined,
            iconColor: currentAccentColor.value,
            textColor: currentAccentColor.value,
          ),
          backgroundColor: Colors.transparent,
          duration: const Duration(seconds: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );
    }
  }

  bool isUpcomingMovieNotified(String movieIdOrTitle) {
    return notifiedUpcomingMovies.contains(movieIdOrTitle);
  }

  void changeCategory(String category) {
    if (selectedCategory.value != category) {
      selectedCategory.value = category;
      _updateAccentColor(category);

      switch (category) {
        case "Movies":
          if (!hasLoadedMovies.value) {
            fetchMovieData();
          }
          break;

        case "Restaurants":
          if (!hasLoadedRestaurants.value) {
            fetchRestaurantData();
          }
          break;

        case "Gadgets":
          if (!hasLoadedGadgets.value) {
            fetchGadgetData();
          }
          break;

        case "Books":
          if (!hasLoadedBooks.value) {
            fetchBookData();
          }
          break;

        case "Games":
          if (!hasLoadedGames.value) {
            fetchGameData();
          }
          break;
      }
    }
  }

  void _updateAccentColor(String category) {
    currentAccentColor.value = getAccentColorForCategory(category);
  }

  Future<void> fetchMovieData() async {
    if (hasLoadedMovies.value) return;

    try {
      //log("🎬 fetchMovieData STARTED");

      isLoadingMovies.value = true;

      final api = ApiService();

      //log("📡 Fetching Featured Movies...");
      final featuredResponse = await api.fetchList('/api/movies/featured');

      //log("✅ Featured Movies Loaded");

      //log("📡 Fetching Trending Movies...");
      final trendingResponse = await api.fetchList('/api/movies/trending');

      //log("✅ Trending Movies Loaded");

      final featuredMovies = featuredResponse
          .map((e) {
            //log("🍔 Featured Movies Parsed: ${e.toString()}");
            return MovieModel.fromApi(e);
          })
          .take(10)
          .toList();

      final trendingMovies = trendingResponse
          .map((e) => MovieModel.fromApi(e))
          .toList();

      movieData.value = MovieDataModel(
        featured: featuredMovies,
        trending: trendingMovies,
        upcoming: [],
        communities: [],
      );

      hasLoadedMovies.value = true;

      //log("✅ Movie Data Assigned");
    } catch (e, stackTrace) {
      //log("❌ Movie API Error: $e");
      //log("🧨 StackTrace: $stackTrace");
    } finally {
      isLoadingMovies.value = false;
      //log("🏁 fetchMovieData FINISHED");
    }
  }

  Future<void> fetchRestaurantData() async {
    if (hasLoadedRestaurants.value) {
      //log("⛔ Restaurants already loaded. Skipping API call.");
      return;
    }

    try {
      //log("🍽 fetchRestaurantData STARTED");

      isLoadingRestaurants.value = true;

      final api = ApiService();

      //log("📡 Fetching Featured Restaurants...");
      final featuredResponse = await api.fetchList('/api/restaurants/featured');

      //log("✅ Featured Restaurants Loaded");

      //log("📡 Fetching Trending Restaurants...");
      final trendingResponse = await api.fetchList('/api/restaurants/trending');

      //log("✅ Trending Restaurants Loaded");

      //log("📦 Featured Response Count: ${featuredResponse.length}");
      //log("📦 Trending Response Count: ${trendingResponse.length}");

      final featuredRestaurants = featuredResponse
          .map((e) {
            //log("🍔 Featured Restaurant Parsed: ${e.toString()}");
            return RestaurantModel.fromApi(e);
          })
          .take(10)
          .toList();

      final trendingRestaurants = trendingResponse.map((e) {
        //log("🔥 Trending Restaurant Parsed: ${e.toString()}");
        return RestaurantModel.fromApi(e);
      }).toList();

      //log("🍽 Featured Restaurants Final Count: ${featuredRestaurants.length}");
      //log("🍽 Trending Restaurants Final Count: ${trendingRestaurants.length}");

      restaurantData.value = RestaurantDataModel(
        featured: featuredRestaurants,
        trending: trendingRestaurants,
        upcoming: [],
        communities: [],
      );

      //log("✅ restaurantData assigned successfully");

      hasLoadedRestaurants.value = true;

      //log("✅ hasLoadedRestaurants set TRUE");
    } catch (e, stackTrace) {
      //log("❌ Restaurant API Error: $e");
      //log("🧨 StackTrace: $stackTrace");
    } finally {
      isLoadingRestaurants.value = false;
      //log("🏁 fetchRestaurantData FINISHED");
    }
  }

  Future<void> fetchGadgetData() async {
    if (hasLoadedGadgets.value) return;

    try {
      isLoadingGadgets.value = true;

      final api = ApiService();

      final responses = await Future.wait([
        api.fetchList('/api/gadgets/featured'),
        api.fetchList('/api/gadgets/trending'),
      ]);

      final featuredResponse = responses[0];
      final trendingResponse = responses[1];

      final featuredGadgets = featuredResponse
          .map((e) => GadgetModel.fromApi(e))
          .take(10)
          .toList();

      final trendingGadgets = trendingResponse
          .map((e) => GadgetModel.fromApi(e))
          .toList();

      gadgetData.value = GadgetDataModel(
        featured: featuredGadgets,
        trending: trendingGadgets,
        upcoming: [],
        communities: [],
      );

      hasLoadedGadgets.value = true;
    } catch (e) {
      //log("Gadget API Error: $e");
    } finally {
      isLoadingGadgets.value = false;
    }
  }

  Future<void> fetchBookData() async {
    if (hasLoadedBooks.value) return;

    try {
      isLoadingBooks.value = true;

      final api = ApiService();

      final responses = await Future.wait([
        api.fetchList('/api/books/featured'),
        api.fetchList('/api/books/trending'),
      ]);

      final featuredResponse = responses[0];
      final trendingResponse = responses[1];

      final featuredBooks = featuredResponse
          .map((e) => BookModel.fromApi(e))
          .take(10)
          .toList();

      final trendingBooks = trendingResponse
          .map((e) => BookModel.fromApi(e))
          .toList();

      bookData.value = BookDataModel(
        featured: featuredBooks,
        trending: trendingBooks,
        upcoming: [],
        communities: [],
      );

      hasLoadedBooks.value = true;
    } catch (e) {
      //log("Book API Error: $e");
    } finally {
      isLoadingBooks.value = false;
    }
  }

  Future<void> fetchGameData() async {
    if (hasLoadedGames.value) return;

    try {
      isLoadingGames.value = true;

      final api = ApiService();

      final responses = await Future.wait([
        api.fetchList('/api/games/featured'),
        api.fetchList('/api/games/trending'),
      ]);

      final featuredResponse = responses[0];
      final trendingResponse = responses[1];

      final featuredGames = featuredResponse
          .map((e) => GameModel.fromApi(e))
          .take(10)
          .toList();

      final trendingGames = trendingResponse
          .map((e) => GameModel.fromApi(e))
          .toList();

      gameData.value = GameDataModel(
        featured: featuredGames,
        trending: trendingGames,
        upcoming: [],
        communities: [],
        discordServers: [],
      );

      hasLoadedGames.value = true;
    } catch (e) {
      //log("Game API Error: $e");
    } finally {
      isLoadingGames.value = false;
    }
  }

  Color getAccentColorForCategory(String category) {
    switch (category) {
      case "Movies":
        return movieAccentColor;
      case "Restaurants":
        return restaurantAccentColor;
      case "Gadgets":
        return gadgetAccentColor;
      case "Books":
        return bookAccentColor;
      case "Games":
        return gameAccentColor;
      default:
        return movieAccentColor;
    }
  }
}

class _CustomSnackbarWidget extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final Color textColor;

  const _CustomSnackbarWidget({
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: textColor),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: ShapeDecoration(
              color: iconColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Icon(icon, color: backgroundColor, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontFamily: 'General Sans Variable',
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
