import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// Assuming your models are in a 'models' directory relative to this file
// Adjust the path if your project structure is different.
import '../models/movie_model.dart';
import '../models/restaurant_model.dart';
import '../models/gadget_model.dart';
import '../models/book_model.dart';
import '../models/game_model.dart';

// Accent Colors
const Color movieAccentColor = Color(0xFF54B6E0); // From HomeScreen
const Color restaurantAccentColor = Color(0xFFF9C74F);
const Color gadgetAccentColor = Color(0xFFE45659);
const Color bookAccentColor = Color(0xFFCDBBE9);
const Color gameAccentColor = Color(0xFF90BE6D);
const Color defaultAccentColor = Colors.teal; // Fallback

class HomeController extends GetxController {
  var selectedCategory = "Movies".obs;
  var categories = <String>['Movies', 'Restaurants', 'Gadgets', 'Books', 'Games'].obs;
  var currentAccentColor = movieAccentColor.obs; // Initialize with default for "Movies"

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
  void toggleItemSaved(String itemId, {String itemName = 'Item'}) {
    if (isItemSaved(itemId)) {
      savedItemIds.remove(itemId);
      print("$itemName with ID $itemId unsaved.");
      Get.snackbar(
        "Removed from Watchlist",
        "$itemName has been removed from your watchlist.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[800],
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
    } else {
      savedItemIds.add(itemId);
      print("$itemName with ID $itemId saved.");
      Get.snackbar(
        "Added to Watchlist!",
        "$itemName has been added to your watchlist.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: currentAccentColor.value, // Uses the current category's color
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
    }
  }

  var movieData = MovieDataModel(featured: [], trending: [], upcoming: [], communities: []).obs;
  var isLoadingMovies = true.obs;
  final RxSet<String> notifiedUpcomingMovies = <String>{}.obs;
  var restaurantData = RestaurantDataModel(
    featured: [],
    trending: [],
    upcoming: [],
    communities: [],
  ).obs;
  var isLoadingRestaurants = true.obs;

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
    communities: [],).obs;
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
    fetchAllData();
  }
  final RxString selectedSurveyOption = "".obs; // Holds the currently selected option
  final RxBool hasSubmittedSurvey = false.obs; // Tracks if the survey has been submitted

  void selectSurveyOption(String option) {
    if (!hasSubmittedSurvey.value) { // Only allow selection if not already submitted
      selectedSurveyOption.value = option;
    }
  }
  void submitSurvey() {
    if (selectedSurveyOption.value.isNotEmpty && !hasSubmittedSurvey.value) {
      // In a real app, you would send selectedSurveyOption.value to a backend here.
      print("Survey Submitted: ${selectedSurveyOption.value}");
      hasSubmittedSurvey.value = true; // Mark as submitted

      // Optional: Provide feedback to the user
      Get.snackbar(
        "Survey Submitted",
        "You selected: ${selectedSurveyOption.value}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green, // Or use controller.currentAccentColor.value
        colorText: Colors.white,
      );
    } else if (hasSubmittedSurvey.value) {
      Get.snackbar(
        "Survey Information",
        "You have already submitted your response for this survey.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Survey Incomplete",
        "Please select an option before submitting.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }
  void resetSurveyState() {
    selectedSurveyOption.value = "";
    hasSubmittedSurvey.value = false;
  }
  void toggleUpcomingMovieNotification(String movieIdOrTitle) {
    if (notifiedUpcomingMovies.contains(movieIdOrTitle)) {
      notifiedUpcomingMovies.remove(movieIdOrTitle); // Remove to toggle off
      print("Notifications OFF for: $movieIdOrTitle");
      Get.snackbar(
        "Notifications Off",
        "We won't notify you about $movieIdOrTitle anymore.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
    } else {
      notifiedUpcomingMovies.add(movieIdOrTitle); // Add to toggle on
      print("Notifications ON for: $movieIdOrTitle");
      Get.snackbar(
        "Notifications On",
        "We'll notify you about $movieIdOrTitle!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: currentAccentColor.value,
        colorText: Colors.white,
      );
    }
  }

  bool isUpcomingMovieNotified(String movieIdOrTitle) {
    return notifiedUpcomingMovies.contains(movieIdOrTitle);
  }

  void fetchAllData() {
    fetchMovieData();
    fetchRestaurantData();
    fetchGadgetData();
    fetchBookData();
    fetchGameData();
  }

  void changeCategory(String category) {
    if (selectedCategory.value != category) {
      selectedCategory.value = category;
      _updateAccentColor(category);
    }
  }

  void _updateAccentColor(String category) {
    switch (category) {
      case "Movies":
        currentAccentColor.value = movieAccentColor;
        break;
      case "Restaurants":
        currentAccentColor.value = restaurantAccentColor;
        break;
      case "Gadgets":
        currentAccentColor.value = gadgetAccentColor;
        break;
      case "Books":
        currentAccentColor.value = bookAccentColor;
        break;
      case "Games":
        currentAccentColor.value = gameAccentColor;
        break;
      default:
        currentAccentColor.value = defaultAccentColor;
    }
  }

  Future<void> fetchMovieData() async {
    try {
      isLoadingMovies.value = true;
      await Future.delayed(const Duration(milliseconds: 800));
      final String response =
      await rootBundle.loadString('assets/json/sample_movie_data.json');
      final data = json.decode(response);
      movieData.value = MovieDataModel.fromJson(data);
    } catch (e) {
      Get.snackbar("Error", "Failed to load movie data: ${e.toString()}");
      // print("Error fetching movie data: $e");
    } finally {
      isLoadingMovies.value = false;
    }
  }

  Future<void> fetchRestaurantData() async {
    try {
      isLoadingRestaurants.value = true;
      await Future.delayed(const Duration(milliseconds: 800));
      final String response = await rootBundle
          .loadString('assets/json/sample_restaurant_data.json');
      final data = json.decode(response);
      restaurantData.value = RestaurantDataModel.fromJson(data);
    } catch (e) {
      Get.snackbar("Error", "Failed to load restaurant data: ${e.toString()}");
    } finally {
      isLoadingRestaurants.value = false;
    }
  }

  Future<void> fetchGadgetData() async {
    try {
      isLoadingGadgets.value = true;
      await Future.delayed(const Duration(milliseconds: 800));
      final String response =
      await rootBundle.loadString('assets/json/sample_gadget_data.json');
      final data = json.decode(response);
      gadgetData.value = GadgetDataModel.fromJson(data);
    } catch (e) {
      Get.snackbar("Error", "Failed to load gadget data: ${e.toString()}");
    } finally {
      isLoadingGadgets.value = false;
    }
  }

  Future<void> fetchBookData() async {
    try {
      isLoadingBooks.value = true;
      await Future.delayed(const Duration(milliseconds: 800));
      final String response =
      await rootBundle.loadString('assets/json/sample_book_data.json');
      final data = json.decode(response);
      bookData.value = BookDataModel.fromJson(data);
    } catch (e) {
      Get.snackbar("Error", "Failed to load book data: ${e.toString()}");
    } finally {
      isLoadingBooks.value = false;
    }
  }

  Future<void> fetchGameData() async {
    try {
      isLoadingGames.value = true;
      await Future.delayed(const Duration(milliseconds: 800));
      final String response =
      await rootBundle.loadString('assets/json/sample_game_data.json');
      final data = json.decode(response);
      gameData.value = GameDataModel.fromJson(data);
    } catch (e) {
      Get.snackbar("Error", "Failed to load game data: ${e.toString()}");
    } finally {
      isLoadingGames.value = false;
    }
  }
}
