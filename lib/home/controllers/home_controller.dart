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

// ✅ Color constants for the new snackbars
const Color snackbarBackgroundColor = Color(0xFF141414);
const Color snackbarSuccessColor = Color(0xFF9DD870);
const Color snackbarWarningColor = Colors.orange;
const Color snackbarInfoColor = Color(0xFF54B6E0);
const Color snackbarNeutralColor = Color(0xFF626365);


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

  // This method is already correct from our previous conversation
  void toggleItemSaved(String itemId, {String itemName = 'Item'}) {
    final String itemDisplayName = itemName.length > 20 ? '${itemName.substring(0, 20)}...' : itemName;

    if (isItemSaved(itemId)) {
      savedItemIds.remove(itemId);
      print("$itemName with ID $itemId unsaved.");

      // Show the "Removed" custom snackbar with neutral colors
      Get.showSnackbar(GetSnackBar(
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
      ));
    } else {
      savedItemIds.add(itemId);
      print("$itemName with ID $itemId saved.");

      // Show the "Added" custom snackbar with dynamic accent colors
      Get.showSnackbar(GetSnackBar(
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
      ));
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

  // ✅ UPDATED: submitSurvey now uses the custom snackbar
  void submitSurvey() {
    if (selectedSurveyOption.value.isNotEmpty && !hasSubmittedSurvey.value) {
      print("Survey Submitted: ${selectedSurveyOption.value}");
      hasSubmittedSurvey.value = true;

      Get.showSnackbar(GetSnackBar(
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
      ));

    } else if (hasSubmittedSurvey.value) {
      Get.showSnackbar(GetSnackBar(
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
      ));

    } else {
      Get.showSnackbar(GetSnackBar(
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
      ));
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
      print("Notifications OFF for: $movieIdOrTitle");

      Get.showSnackbar(GetSnackBar(
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
      ));

    } else {
      notifiedUpcomingMovies.add(movieIdOrTitle);
      print("Notifications ON for: $movieIdOrTitle");

      Get.showSnackbar(GetSnackBar(
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
      ));
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
      print("Error fetching movie data: $e");
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
      print("Error fetching restaurant data: $e");
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
      print("Error fetching gadget data: $e");
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
      print("Error fetching book data: $e");
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
      print("Error fetching game data: $e");
    } finally {
      isLoadingGames.value = false;
    }
  }

  Color getAccentColorForCategory(String category) {
    switch (category) {
      case "Movies":
        return const Color(0xFF54B6E0);
      case "Restaurants":
        return const Color(0xFFF28500);
      case "Gadgets":
        return const Color(0xFFE45659);
      case "Books":
        return const Color(0xFFCDBBE9);
      case "Games":
        return const Color(0xFF90BE6D);
      default:
        return const Color(0xFF54B6E0);
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
          side: BorderSide(
            width: 2,
            color: textColor,
          ),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
