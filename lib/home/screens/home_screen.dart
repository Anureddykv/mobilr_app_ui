import 'dart:math' show min;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/bottomnav/notification_screen.dart';
import 'package:mobilr_app_ui/bottomnav/profile_screen.dart';
import 'package:mobilr_app_ui/bottomnav/search_screen.dart';
import 'package:mobilr_app_ui/home/bottomsheet/FeatureScreenJoinedCommunityList.dart';
import 'package:mobilr_app_ui/home/bottomsheet/community_join_bottom_sheet.dart';
import 'package:mobilr_app_ui/home/bottomsheet/more_info_bottom_sheet.dart';
import 'package:mobilr_app_ui/home/models/book_model.dart';
import 'package:mobilr_app_ui/home/models/gadget_model.dart';
import 'package:mobilr_app_ui/home/models/game_model.dart';
import 'package:mobilr_app_ui/home/models/restaurant_model.dart';
import 'package:mobilr_app_ui/home/screens/commonscreen/TrendingCard.dart';
import 'package:mobilr_app_ui/home/screens/commonscreen/communityCard.dart';
import 'package:mobilr_app_ui/home/screens/commonscreen/featured_card.dart';
import 'package:mobilr_app_ui/home/screens/commonscreen/survey_card.dart';
import 'package:mobilr_app_ui/home/screens/commonscreen/trending_section.dart';
import 'package:mobilr_app_ui/home/screens/commonscreen/upcoming_section.dart';
import 'package:mobilr_app_ui/home/screens/featured_content_card_large.dart';
import 'package:mobilr_app_ui/home/widgets/HorizontalCardList.dart';
import 'package:mobilr_app_ui/home/widgets/ReusableCarousel.dart';
import 'package:mobilr_app_ui/home/widgets/buttons/buildSectionTitle.dart';
import 'package:mobilr_app_ui/home/widgets/buttons/filledButton.dart';
import 'package:mobilr_app_ui/review/MainReviewScreenBooks.dart';
import 'package:mobilr_app_ui/review/MainReviewScreenGadgets.dart';
import 'package:mobilr_app_ui/review/MainReviewScreenGames.dart';
import 'package:mobilr_app_ui/review/MainReviewScreenMovies.dart';
import 'package:mobilr_app_ui/chat/features_screen_community.dart';
import 'package:mobilr_app_ui/review/MainReviewScreenRestaurants.dart';
import 'package:mobilr_app_ui/review/add_edit_review_screen.dart';
import '../controllers/home_controller.dart';
import '../models/movie_model.dart'; // Ensure this path is correct
import 'package:mobilr_app_ui/widgets/tinted_asset_image.dart';

import 'discord_section.dart';

const Color movieAccentColor = Color(0xFF54B6E0);
const Color darkBackgroundColor = Color(0xFF0B0B0B);
const Color cardBackgroundColor = Color(0xFF141414);
const Color secondaryTextColor = Color(0xFF626365);
const Color primaryTextColor = Colors.white;
const Color gameAccentColor = Color(0xFF90BE6D);
const Color bookAccentColor = Color(0xFFCDBBE9);
const Color gadgetAccentColor = Color(0xFFE45659);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final HomeController controller = Get.put(HomeController());
  late TabController _tabController;
  late PageController _nowShowingPageController;

  final ScrollController _trendingScrollController = ScrollController();
  int _currentTrendingIndex = 0;
  final double _trendingCardWidth = 355;
  final double _trendingCardSpacing = 10;
  final List<Map<String, dynamic>> _placeholderTrendingMovies = [
    {
      "movieId": "m1",
      "title": "MAHAVATAR NARASIMHA",
      "duration": "2h 35m",
      "certification": "U/A",
      "language": "Telugu",
      "starnestRating": "4.5",
      "audienceRating": "4.3",
      "audienceVotes": "2.1k",
      "imageUrl":
          "https://placehold.co/121x184/141414/626365?text=Mahavatar&font=sans",
    },
    {
      "movieId": "m2",
      "title": "KINGDOM",
      "duration": "2h 35m",
      "certification": "U/A",
      "language": "Telugu",
      "starnestRating": "4.5",
      "audienceRating": "4.3",
      "audienceVotes": "2.1k",
      "imageUrl":
          "https://placehold.co/121x184/141414/626365?text=Kingdom&font=sans",
    },
    {
      "movieId": "m3",
      "title": "KUBERAA",
      "duration": "2h 15m",
      "certification": "U",
      "language": "Hindi",
      "starnestRating": "4.1",
      "audienceRating": "4.0",
      "audienceVotes": "1.5k",
      "imageUrl":
          "https://placehold.co/121x184/141414/626365?text=Kuberaa&font=sans",
    },
    {
      "movieId": "m4",
      "title": "AVENGERS ENDGAME",
      "duration": "3h 02m",
      "certification": "U/A",
      "language": "English",
      "starnestRating": "4.8",
      "audienceRating": "4.9",
      "audienceVotes": "10M",
      "imageUrl":
          "https://placehold.co/121x184/141414/626365?text=Avengers&font=sans",
    },
  ];
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: controller.categories.length,
      vsync: this,
    );
    _tabController.addListener(() {
      final newIndex = _tabController.index;
      if (newIndex >= 0 && newIndex < controller.categories.length) {// We get the new category based on the new index.
        final newCategory = controller.categories[newIndex];
        final newColor = controller.getAccentColorForCategory(newCategory);
        if (controller.currentAccentColor.value != newColor) {
          controller.currentAccentColor.value = newColor;
        }
      }
      if (!_tabController.indexIsChanging) {
        controller.changeCategory(controller.categories[_tabController.index]);
      }
    });
    _nowShowingPageController = PageController(viewportFraction: 0.92);
    _trendingScrollController.addListener(_trendingScrollListener);

    _pages = [
      _buildHomeContent(),
      FeatureScreenJoinedCommunityList(),
      const SearchScreen(),
      NotificationScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nowShowingPageController.dispose();
    _trendingScrollController.removeListener(_trendingScrollListener);
    _trendingScrollController.dispose();
    super.dispose();
  }

  void _trendingScrollListener() {
    double currentOffset = _trendingScrollController.offset;
    int newIndex = (currentOffset / (_trendingCardWidth + _trendingCardSpacing))
        .round();
    final int trendingMoviesLength = _placeholderTrendingMovies.length;

    if (_currentTrendingIndex != newIndex) {
      if (newIndex >= 0 && newIndex < trendingMoviesLength) {
        setState(() => _currentTrendingIndex = newIndex);
      } else if (newIndex >= trendingMoviesLength && trendingMoviesLength > 0) {
        if (_currentTrendingIndex != trendingMoviesLength - 1) {
          setState(() => _currentTrendingIndex = trendingMoviesLength - 1);
        }
      } else if (newIndex < 0 && _currentTrendingIndex != 0) {
        setState(() => _currentTrendingIndex = 0);
      }
    }
  }

  Widget _dot() => Container(
    width: 3,
    height: 3,
    decoration: const BoxDecoration(
      color: secondaryTextColor,
      shape: BoxShape.circle,
    ),
  );

  Widget buildMoviesTab() {
    return Obx(() {
      final movieData = controller.movieData.value;
      if (controller.isLoadingMovies.value &&
          movieData.featured.isEmpty &&
          movieData.trending.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(movieAccentColor),
          ),
        );
      }
      final EdgeInsets listViewPadding = const EdgeInsets.only(
        top: 10,
        bottom: 12,
      );
      return ListView(
      //  padding: listViewPadding,
        children: [
          if (movieData.featured.isNotEmpty)
            ReusableCarousel<MovieModel>(
              context,
              items: movieData.featured.obs,
              controller: controller,
              cardBuilder: (movie) {
                return FeaturedContentCardLarge(
                  imageUrl: movie.imageUrl,
                  title: movie.title ?? 'Unknown Movie',
                  infoItems: [
                    movie.duration ?? 'N/A',
                    movie.certification ?? 'N/A',
                    movie.language ?? 'N/A',
                  ],
                  rating: movie.rating?.toStringAsFixed(1) ?? 'N/A',
                  votes: "${movie.votes ?? 0} Votes",
                  ratingIcon: Image.asset(
                    "assets/images/sd.png",
                    width: 14,
                    height: 14,
                    color: movieAccentColor,
                  ),
                  accentColor: movieAccentColor,
                  onMoreInfo: () {
                    _showMoreInfoBottomSheet(
                      title: movie.title ?? "Unknown Title",
                      rating: movie.rating.toStringAsFixed(1) ?? "0.0",
                      votes: "${movie.votes ?? '0'} Votes",
                      infoItems: [
                        movie.duration ?? 'N/A',
                        movie.certification ?? 'N/A',
                        movie.language ?? 'N/A',
                      ],
                      description:
                          movie.description ?? 'No description available.',
                      cast:
                          movie.genres
                              ?.map(
                                (c) => ActorInfo(
                                  name: "c.name",
                                  role: "c.role",
                                  imageUrl: "c.imageUrl",
                                ),
                              )
                              .toList() ??
                          [],
                      accentColor: movieAccentColor,
                      ratingIconAsset: "assets/images/sd.png",
                      onPrimaryButtonTap: () {
                        Get.to(() => MainReviewScreenMovies(movieId: movie.id));
                      },
                      itemId: movie.id,
                    );
                  },
                  onViewAllReviews: () {
                    Get.to(() => MainReviewScreenMovies(movieId: movie.id));
                  },
                  itemId: movie.id,
                );
              },
            ),
          _buildFeaturedTeluguSection(),
          _buildNewTrendingSection(),
          _buildUpcomingReleasesSection(),
          _buildExploreCommunitiesSection(),
          _buildSurveySection(),
          const SizedBox(height: 20),
        ],
      );
    });
  }

  Widget _buildFeaturedTeluguSection() {
    final List<Map<String, String>> featuredMovies = [
      {
        "id": "coolie_01",
        "title": "Coolie",
        "rating": "4.3",
        "imageUrl":
            "https://placehold.co/152x174/141414/626365?text=Coolie&font=sans",
      },
      {
        "id": "kingdom_02",
        "title": "Kingdom",
        "rating": "4.5",
        "imageUrl":
            "https://placehold.co/152x174/141414/626365?text=Kingdom&font=sans",
      },
      {
        "id": "3bhk_03",
        "title": "3 BHK",
        "rating": "4.3",
        "imageUrl":
            "https://placehold.co/152x174/141414/626365?text=3+BHK&font=sans",
      },
      {
        "id": "mahavatar_04",
        "title": "Mahavatar\nNarasimha",
        "rating": "4.6",
        "imageUrl":
            "https://placehold.co/152x174/141414/626365?text=Mahavatar&font=sans",
      },
    ];
    return HorizontalCardList<Map<String, String>>(
      title: 'FEATURED TELUGU',
      items: featuredMovies,
      cardBuilder: (context, movie) {
        return FeaturedContentCard(
          imageUrl: movie['imageUrl']!,
          title: movie['title']!,
          rating: movie['rating'],
          ratingIconAsset: "assets/images/sd.png",
          activeRatingIconColor: movieAccentColor,
          inactiveRatingIconColor: Colors.white,
          onTap: () {
            Get.to(() => MainReviewScreenMovies(movieId: movie['id']!));
            print("Explore tapped for ${movie['title']}");
          },
        );
      },
    );
  }

  Widget _buildNewTrendingSection() {
    final List<Map<String, dynamic>> _placeholderTrendingMovies = [
      {
        "movieId": "movie1",
        "title": "Kalki 2898 AD",
        "duration": "3h 1m",
        "certification": "U/A",
        "language": "Telugu",
        "starnestRating": "4.5",
        "audienceRating": "4.8",
        "audienceVotes": "15k",
        "imageUrl":
            "https://placehold.co/355x184/141414/626365?text=Kalki&font=sans",
      },
      {
        "movieId": "movie2",
        "title": "Pushpa 2: The Rule",
        "duration": "2h 50m",
        "certification": "U/A",
        "language": "Telugu",
        "starnestRating": "4.9",
        "audienceRating": "4.9",
        "audienceVotes": "25k",
        "imageUrl":
            "https://placehold.co/355x184/141414/626365?text=Pushpa+2&font=sans",
      },
    ];

    // Convert the list to a reactive RxList for the carousel
    final RxList<Map<String, dynamic>> trendingMovies =
        _placeholderTrendingMovies.obs;

    return TrendingCarousel<Map<String, dynamic>>(
      context: context, // Pass context directly to the carousel
      items: trendingMovies,
      cardBuilder: (movie) {
        // cardBuilder now only takes the item
        final details = [
          movie["duration"] ?? "N/A",
          movie["certification"] ?? "N/A",
          movie["language"] ?? "N/A",
        ].join(' • ');

        return TrendingCard(
          imageUrl: movie["imageUrl"] ?? "",
          title: movie["title"] ?? "Unknown Title",
          details: details,
          starnestRating: movie["starnestRating"] ?? "0.0",
          audienceRating: movie["audienceRating"] ?? "0.0",
          audienceVotes: movie["audienceVotes"] ?? "0 votes",
          ratingImage: Image.asset(
            "assets/images/sd.png",
            width: 14,
            height: 14,
            color: movieAccentColor,
          ),
          exploreButtonImage: Image.asset(
            "assets/images/ic_sd.png",
            width: 14,
            height: 14,
            color: Colors.white,
          ),
          exploreButtonImageColor: movieAccentColor,
          onExplore: () {
            print("Explore tapped for ${movie['title']}");
            Get.to(() => MainReviewScreenMovies(movieId: movie["movieId"]));
          },
          onWriteReview: () {
            print("Write a Review for ${movie['title']}");
            Get.to(
              () => AddEditReviewScreen(
                itemName: movie['title'] ?? "this Movie",
                itemType: "Movie",
                accentColor: movieAccentColor,
                ratingAssetPath: "assets/images/sd.png",
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUpcomingReleasesSection() {
    final List<Map<String, String>> upcomingMovies = [
      {
        "id": "ghaati_01",
        "title": "Ghaati",
        "details": "Horror, Thriller, 2h 30m",
        "releaseDate": "5 Sept, 2025",
        "imageUrl": "https://placehold.co/300x400/141414/ffffff?text=Ghaati",
      },
      {
        "id": "akhanda2_02",
        "title": "Akhanda 2",
        "details": "Action, Drama, 2h 24m",
        "releaseDate": "25 Sept, 2025",
        "imageUrl": "https://placehold.co/300x400/141414/ffffff?text=Akhanda+2",
      },
      {
        "id": "kalki_03",
        "title": "Kalki 2898 AD",
        "details": "Sci-fi, Action, 3h 00m",
        "releaseDate": "15 Jan, 2024",
        "imageUrl": "https://placehold.co/300x400/1E1E1E/ffffff?text=Kalki",
      },
    ];
    return HorizontalCardList<Map<String, String>>(
      title: 'UPCOMING RELEASES',
      items: upcomingMovies,
      listHeight: 320,
      cardBuilder: (context, movie) {
        final String movieId = movie["id"]!;
        return Obx(() {
          final bool isNotified = controller.isUpcomingMovieNotified(movieId);
          return UpcomingContentCard(
            id: movieId,
            title: movie['title']!,
            imageUrl: movie['imageUrl']!,
            details: movie['details']!,
            releaseDate: movie['releaseDate']!,
            isNotified: isNotified,
            accentColor: controller.currentAccentColor.value,

            onNotifyToggle: () {
              controller.toggleUpcomingMovieNotification(movieId);
              print("Notify toggled for ${movie['title']}");
            },
            onExplore: () {
              print("Explore tapped for ${movie['title']}");
              // Example: Get.to(() => MovieDetailsScreen(movieId: movieId));
            },
            infoIcon: const Icon(
              Icons.info_outline,
              size: 16,
              color: movieAccentColor,
            ),
            notifyIcon: Image.asset(
              width: 14,
              height: 14,
              "assets/images/notification.png",
              color: Colors.white,
            ),
            notifiedIcon: Image.asset(
              "assets/images/notify_check.png",
              color: Colors.white,
              width: 14,
              height: 14,
            ),
          );
        });
      },
    );
  }

  Widget _buildExploreCommunitiesSection() {
    final List<Map<String, String>> communities = [
      {
        "id": "dino123",
        "name": "Dinosaur Club",
        "desc": "Prabhas Fans Association",
        "imageUrl": "https://placehold.co/40x40/D9D9D9/000?text=DC&font=sans",
      },
      {
        "id": "rebel456",
        "name": "Rebel Stars",
        "desc": "Allu Arjun Army",
        "imageUrl": "https://placehold.co/40x40/D9D9D9/000?text=RS&font=sans",
      },
      {
        "id": "buffs789",
        "name": "Movie Buffs HYD",
        "desc": "Telugu Cinema Lovers",
        "imageUrl": "https://placehold.co/40x40/D9D9D9/000?text=MB&font=sans",
      },
    ];
    return HorizontalCardList<Map<String, String>>(
      title: 'EXPLORE COMMUNITIES',
      items: communities,
      listHeight: 120,
      cardBuilder: (context, community) {
        return Obx(() {
          return CommunityCard(
            name: community['name']!,
            description: community['desc']!,
            imageUrl: community['imageUrl']!,
            accentColor: controller.currentAccentColor.value,
            onJoin: () {
              print("Joining community: ${community['name']}");
              _showCommunityJoinSheet(community);
            },
            buttonIcon: Image.asset(
              width: 14,
              height: 14,
              "assets/images/pepole.png",
              color: Colors.white,
            ),
          );
        });
      },
    );
  }

  Widget _buildSurveySection() {
    final movieSurvey = Survey(
      id: 'movie_excitement_survey',
      question: 'How excited are you about the upcoming movie Mass Jathara?',
      options: [
        SurveyOption(id: 'opt1', text: "Super Excited"),
        SurveyOption(id: 'opt2', text: "Excited"),
        SurveyOption(id: 'opt3', text: "Neutral"),
        SurveyOption(id: 'opt4', text: "Some What"),
        SurveyOption(id: 'opt5', text: "Not Really"),
      ],
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('SURVEY'),
        const SizedBox(height: 10),
        Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SurveyCard(
              survey: movieSurvey,
              accentColor: controller.currentAccentColor.value,
              onSubmit: (String selectedOptionId) {
                print(
                  "Survey submitted! Selected option ID: $selectedOptionId",
                );
              },
              filledButtonBuilder: (text, {background, onTap}) {
                return filledButton(
                  text,
                  background: background ?? controller.currentAccentColor.value,
                  onTap: onTap,
                  fontSize: 12,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// --------------------------------------

  Widget buildRestaurantsTab() {
    return Obx(() {
      final restaurantsData = controller.restaurantData.value;
      if (controller.isLoadingRestaurants.value &&
          restaurantsData.featured.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF9C74F)),
          ),
        );
      }

      final EdgeInsets listViewPadding = const EdgeInsets.only(
        top: 10,
        bottom: 12,
      );

      return ListView(
      //  padding: listViewPadding,
        children: [
          if (restaurantsData.featured.isNotEmpty)
            ReusableCarousel<RestaurantModel>(
              context,
              items: restaurantsData.featured.obs,
              controller: controller,
              cardBuilder: (restaurant) {
                return FeaturedContentCardLarge(
                  imageUrl: restaurant.imageUrl,
                  title: restaurant.name ?? 'Unknown Restaurant',
                  infoItems: [
                    restaurant.cuisineType ?? 'N/A',
                    restaurant.address ?? 'N/A',
                  ],
                  rating: restaurant.rating.toStringAsFixed(1),
                  votes: "1.5k+ Reviews", // Example data, adjust as needed
                  ratingIcon: Image.asset(
                    "assets/images/restaurants.png",
                    width: 14,
                    height: 14,
                    color: restaurantAccentColor,
                  ),
                  accentColor: restaurantAccentColor,
                  onMoreInfo: () {
                    _showMoreInfoBottomSheet(
                      title: restaurant.name,
                      rating: restaurant.rating.toStringAsFixed(1),
                      votes: "1.5k+ Reviews",
                      cast:
                          restaurant.offers
                              ?.map(
                                (c) => ActorInfo(
                                  name: "c.name",
                                  role: "c.role",
                                  imageUrl: "c.imageUrl",
                                ),
                              )
                              .toList() ??
                          [],
                      infoItems: [
                        restaurant.cuisineType ?? "Cuisine",
                        restaurant.eta ?? "25-30 min",
                      ],
                      description:
                          "A popular restaurant known for its delicious food and great ambiance.",
                      accentColor: restaurantAccentColor,
                      ratingIconAsset: "assets/images/restaurants.png",
                      onPrimaryButtonTap: () {
                        print("Opening menu for ${restaurant.name}...");
                        Get.to(
                          () => RestaurantReviewScreen(itemId: restaurant.id),
                        );
                      },
                      itemId: restaurant.id,
                    );
                  },
                  onViewAllReviews: () {
                    Get.to(() => RestaurantReviewScreen(itemId: restaurant.id));
                  },
                  itemId: restaurant.id,
                );
              },
            ),
          _buildFeaturedRestaurantsSection(),
          _buildTrendingRestaurantsSection(),
          _buildUpcomingRestaurantsSection(),
          _buildFoodieCommunitiesSection(),
          _buildRestaurantSurveySection(),
          const SizedBox(height: 20),
        ],
      );
    });
  }

  Widget _buildFeaturedRestaurantsSection() {
    final List<Map<String, String>> featuredRestaurants = [
      {
        "id": "paradise456",
        "title": "Paradise",
        "rating": "4.5",
        "imageUrl":
            "https://placehold.co/152x174/141414/626365?text=Paradise&font=sans",
      },
      {
        "id": "bawarchi123",
        "title": "Bawarchi",
        "rating": "4.6",
        "imageUrl":
            "https://placehold.co/152x174/141414/626365?text=Bawarchi&font=sans",
      },
      {
        "id": "kritunga789",
        "title": "Kritunga",
        "rating": "4.2",
        "imageUrl":
            "https://placehold.co/152x174/141414/626365?text=Kritunga&font=sans",
      },
    ];
    return HorizontalCardList<Map<String, String>>(
      title: 'FEATURED RESTAURANTS',
      items: featuredRestaurants,
      cardBuilder: (context, restaurant) {
        return FeaturedContentCard(
          imageUrl: restaurant['imageUrl']!,
          title: restaurant['title']!,
          rating: restaurant['rating'],
          ratingIconAsset: "assets/images/restaurants.png",
          activeRatingIconColor: restaurantAccentColor,
          inactiveRatingIconColor: Colors.white,
          onTap: () {
            print("Explore tapped for ${restaurant['title']}");
            Get.to(() => RestaurantReviewScreen(itemId: restaurant['id']!));
          },
        );
      },
    );
  }

  Widget _buildTrendingRestaurantsSection() {
    // Convert the static list to a reactive list (RxList) for the carousel
    final RxList<Map<String, dynamic>> trendingRestaurants = [
      {
        "restaurantId": "r1",
        "title": "Mehfil",
        "cuisine": "Indian, Hyderabadi",
        "area": "Gachibowli",
        "starnestRating": "4.8",
        "audienceRating": "4.7",
        "audienceVotes": "3.5k",
        "imageUrl":
            "https://placehold.co/355x184/141414/626365?text=Mehfil&font=sans",
      },
      {
        "restaurantId": "r2",
        "title": "Olive Garden",
        "cuisine": "Italian",
        "area": "Jubilee Hills",
        "starnestRating": "4.6",
        "audienceRating": "4.5",
        "audienceVotes": "1.8k",
        "imageUrl":
            "https://placehold.co/355x184/141414/626365?text=Olive+Garden&font=sans",
      },
    ].obs; // Use .obs to make the list reactive

    // Use the corrected TrendingCarousel widget
    return TrendingCarousel<Map<String, dynamic>>(
      context: context, // Pass context directly to the carousel
      items: trendingRestaurants,
      cardBuilder: (restaurant) {
        // cardBuilder now only takes the item
        final details = "${restaurant["cuisine"]}, ${restaurant["area"]}";

        return TrendingCard(
          imageUrl: restaurant["imageUrl"] ?? "",
          title: restaurant["title"] ?? "Unknown Title",
          details: details,
          starnestRating: restaurant["starnestRating"] ?? "0.0",
          audienceRating: restaurant["audienceRating"] ?? "0.0",
          audienceVotes: restaurant["audienceVotes"] ?? "0 votes",
          ratingImage: Image.asset(
            "assets/images/restaurants.png",
            width: 14,
            height: 14,
            color: restaurantAccentColor,
          ),
          exploreButtonImage: Image.asset(
            "assets/images/restaurants.png",
            width: 14,
            height: 14,
            color: Colors.white,
          ),
          exploreButtonImageColor: restaurantAccentColor,
          onExplore: () {
            print("Explore tapped for ${restaurant['title']}");
            Get.to(
              () => RestaurantReviewScreen(itemId: restaurant["restaurantId"]),
            );
          },
          onWriteReview: () {
            Get.to(
              () => AddEditReviewScreen(
                itemName: restaurant['title'] ?? "this Restaurant",
                itemType: "Restaurant",
                accentColor: restaurantAccentColor,
                ratingAssetPath: "assets/images/restaurants.png",
              ),
            );
            print("Write a Review for ${restaurant['title']}");
          },
        );
      },
    );
  }

  Widget _buildUpcomingRestaurantsSection() {
    final List<Map<String, String>> upcomingItems = [
      {
        "id": "new_biryani_spot",
        "title": "New Biryani Spot",
        "details": "Authentic Hyderabadi, Opening Soon",
        "releaseDate": "15 Nov, 2025",
        "imageUrl":
            "https://placehold.co/300x400/141414/ffffff?text=New+Eatery",
      },
    ];
    return HorizontalCardList<Map<String, String>>(
      title: 'UPCOMING OPENING',
      items: upcomingItems,
      listHeight: 320,
      cardBuilder: (context, item) {
        final String itemId = item["id"]!;
        return Obx(() {
          final bool isNotified = controller.isUpcomingMovieNotified(
            itemId,
          ); // You can reuse the logic
          return UpcomingContentCard(
            id: itemId,
            title: item['title']!,
            imageUrl: item['imageUrl']!,
            details: item['details']!,
            releaseDate: item['releaseDate']!,
            isNotified: isNotified,
            accentColor: restaurantAccentColor, // Use correct color
            onNotifyToggle: () =>
                controller.toggleUpcomingMovieNotification(itemId),
            onExplore: () {
              print("Explore tapped for ${item['title']}");
              Get.to(() => RestaurantReviewScreen(itemId: itemId));
            },
            infoIcon: const Icon(
              Icons.info_outline,
              size: 16,
              color: restaurantAccentColor,
            ),
            notifyIcon: Image.asset(
              width: 14,
              height: 14,
              "assets/images/foodicon.png",
              color: Colors.white,
            ),
            notifiedIcon: Image.asset(
              "assets/images/food_check.png",
              color: Colors.white,
              width: 14,
              height: 14,
            ),
            notifyButtonText: "Reserve Table",
          );
        });
      },
    );
  }

  Widget _buildFoodieCommunitiesSection() {
    final List<Map<String, String>> communities = [
      {
        "id": "foodies_hyd",
        "name": "Hyderabad Foodies",
        "desc": "Find the best biryani!",
        "imageUrl": "https://placehold.co/40x40/D9D9D9/000?text=HF&font=sans",
      },
      {
        "id": "cafe_hoppers",
        "name": "Cafe Hoppers Club",
        "desc": "Exploring new cafes",
        "imageUrl": "https://placehold.co/40x40/D9D9D9/000?text=CHC&font=sans",
      },
    ];
    return HorizontalCardList<Map<String, String>>(
      title: 'EXPLORE FOODIE COMMUNITIES',
      items: communities,
      listHeight: 120,
      cardBuilder: (context, community) {
        return Obx(() {
          return CommunityCard(
            name: community['name']!,
            description: community['desc']!,
            imageUrl: community['imageUrl']!,
            accentColor: controller.currentAccentColor.value,
            onJoin: () {
              print("Joining community: ${community['name']}");
              Get.to(
                () => FeaturesScreenCommunity(
                  communityId: community['id']!,
                  communityName: community['name']!,
                  communityImageUrl: community['imageUrl']!,
                ),
              );
            },
            buttonIcon: Image.asset(
              width: 14,
              height: 14,
              "assets/images/pepole.png",
              color: Colors.white,
            ),
          );
        });
      },
    );
  }

  Widget _buildRestaurantSurveySection() {
    final restaurantSurvey = Survey(
      id: 'biryani_preference_survey',
      question: 'Which restaurant serves the best Hyderabadi Biryani?',
      options: [
        SurveyOption(id: 'opt_paradise', text: "Paradise"),
        SurveyOption(id: 'opt_bawarchi', text: "Bawarchi"),
        SurveyOption(id: 'opt_shadab', text: "Shadab"),
        SurveyOption(id: 'opt_other', text: "Other"),
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle('SURVEY'),
          const SizedBox(height: 10),
          Obx(
            () => SurveyCard(
              survey: restaurantSurvey,
              accentColor: controller.currentAccentColor.value,
              onSubmit: (String selectedOptionId) {
                print(
                  "Survey submitted! Selected option ID: $selectedOptionId",
                );
              },
              filledButtonBuilder: (text, {background, onTap}) {
                return filledButton(
                  text,
                  background: background ?? controller.currentAccentColor.value,
                  onTap: onTap,
                  fontSize: 12,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// --------------------------------------

  Widget buildGadgetsTab() {
    return Obx(() {
      final gadgetData = controller.gadgetData.value;
      if (controller.isLoadingGadgets.value && gadgetData.featured.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(gadgetAccentColor),
          ),
        );
      }

      return ListView(
       // padding: const EdgeInsets.only(top: 12, bottom: 24),
        children: [
          if (gadgetData.featured.isNotEmpty)
            ReusableCarousel<GadgetModel>(
              context,
              items: gadgetData.featured.obs,
              controller: controller,
              cardBuilder: (gadget) {
                return FeaturedContentCardLarge(
                  imageUrl: gadget.imageUrl,
                  title: gadget.name,
                  infoItems: [
                    gadget.brand,
                    ...gadget.keyFeatures,
                  ].where((s) => s.isNotEmpty).toList(),
                  rating: gadget.rating?.toStringAsFixed(1) ?? 'N/A',
                  votes: "${gadget.votes ?? '0'} Votes",
                  ratingIcon: Image.asset(
                    "assets/images/gadget.png",
                    width: 14,
                    height: 14,
                    color: gadgetAccentColor,
                  ),
                  accentColor: gadgetAccentColor,
                  onMoreInfo: () {
                    _showMoreInfoBottomSheet(
                      title: gadget.name,
                      rating: gadget.rating?.toStringAsFixed(1) ?? "N/A",
                      votes: gadget.votes ?? "0 Votes",
                      infoItems: gadget.keyFeatures,
                      description:
                          gadget.description ??
                          "A brand new gadget from ${gadget.brand}.",
                      accentColor: gadgetAccentColor,
                      ratingIconAsset: "assets/images/gadget.png",
                      onPrimaryButtonTap: () => Get.to(
                        () => MainReviewScreenGadgets(gadgetId: gadget.id),
                      ),
                      itemId: gadget.id,
                    );
                  },
                  onViewAllReviews: () => Get.to(
                    () => MainReviewScreenGadgets(gadgetId: gadget.id),
                  ),
                  itemId: gadget.id,
                );
              },
            ),
          _buildFeaturedGadgetsSection(),
          if (gadgetData.trending.isNotEmpty)
            _buildTrendingGadgetsSection(gadgetData.trending),
          _buildUpcomingGadgetsSection(),
          _buildTechCommunitiesSection(),
          _buildGadgetSurveySection(),
          const SizedBox(height: 20),
        ],
      );
    });
  }

  Widget _buildTrendingGadgetsSection(List<GadgetModel> trendingGadgets) {
    if (trendingGadgets.isEmpty) return const SizedBox.shrink();

    // Convert the list to a reactive list for the carousel
    final RxList<GadgetModel> trendingGadgetsRx = trendingGadgets.obs;

    return TrendingCarousel<GadgetModel>(
      context: context, // Pass context directly to the carousel
      items: trendingGadgetsRx,
      cardBuilder: (gadget) {
        // cardBuilder now only takes the item
        final details = [
          gadget.brand,
          ...gadget.keyFeatures,
        ].where((s) => s.isNotEmpty).join(' • ');

        return TrendingCard(
          imageUrl: gadget.imageUrl,
          title: gadget.name,
          details: details,
          starnestRating: gadget.rating?.toStringAsFixed(1) ?? "N/A",
          audienceRating:
              "4.8", // This seems to be a placeholder, adjust as needed
          audienceVotes: gadget.votes ?? "0 votes",
          ratingImage: Image.asset(
            "assets/images/gadget.png",
            width: 14,
            height: 14,
            color: gadgetAccentColor,
          ),
          exploreButtonImage: Image.asset(
            "assets/images/gadget.png",
            width: 14,
            height: 14,
            color: Colors.white,
          ),
          exploreButtonImageColor: gadgetAccentColor,
          onExplore: () {
            print("Explore tapped for ${gadget.name}");
            Get.to(() => MainReviewScreenGadgets(gadgetId: gadget.id));
          },
          onWriteReview: () {
            Get.to(
              () => AddEditReviewScreen(
                itemName: gadget.name,
                itemType: "Gadget",
                accentColor: gadgetAccentColor,
                ratingAssetPath: "assets/images/gadget.png",
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFeaturedGadgetsSection() {
    final featuredGadgets = controller.gadgetData.value.featured;
    if (featuredGadgets.isEmpty) return const SizedBox.shrink();

    return HorizontalCardList<GadgetModel>(
      title: 'FEATURED GADGETS',
      items: featuredGadgets,
      cardBuilder: (context, gadget) {
        return FeaturedContentCard(
          imageUrl: gadget.imageUrl,
          title: gadget.name,
          rating: gadget.rating?.toStringAsFixed(1),
          ratingIconAsset: "assets/images/gadget.png",
          activeRatingIconColor: gadgetAccentColor,
          inactiveRatingIconColor: Colors.white,
          onTap: () {
            print("Explore tapped for ${gadget.name}");
            Get.to(() => MainReviewScreenGadgets(gadgetId: gadget.id));
          },
        );
      },
    );
  }

  Widget _buildUpcomingGadgetsSection() {
    final List<Map<String, String>> upcomingItems = [
      {
        "id": "iphone_17",
        "title": "iPhone 17",
        "details": "A19 Bionic, Dynamic Island Gen 2",
        "releaseDate": "12 Sept, 2025",
        "imageUrl": "https://placehold.co/300x400/141414/ffffff?text=iPhone+17",
      },
      {
        "id": "galaxy_s26",
        "title": "Galaxy S26 Ultra",
        "details": "Snapdragon 9 Gen 4, 200MP Cam",
        "releaseDate": "20 Jan, 2026",
        "imageUrl": "https://placehold.co/300x400/141414/ffffff?text=S26+Ultra",
      },
    ];
    return HorizontalCardList<Map<String, String>>(
      title: 'UPCOMING GADGETS',
      items: upcomingItems,
      listHeight: 320,
      cardBuilder: (context, item) {
        final String itemId = item["id"]!;
        return Obx(() {
          final bool isNotified = controller.isUpcomingMovieNotified(itemId);
          return UpcomingContentCard(
            id: itemId,
            title: item['title']!,
            imageUrl: item['imageUrl']!,
            details: item['details']!,
            releaseDate: item['releaseDate']!,
            isNotified: isNotified,
            accentColor: gadgetAccentColor,
            onNotifyToggle: () =>
                controller.toggleUpcomingMovieNotification(itemId),
            onExplore: () {
              print("Explore tapped for ${item['title']}");
              Get.to(() => MainReviewScreenGadgets(gadgetId: itemId));
            },
            infoIcon: const Icon(
              Icons.info_outline,
              size: 16,
              color: gadgetAccentColor,
            ),
            notifyIcon: Image.asset(
              width: 14,
              height: 14,
              "assets/images/notification.png",
              color: Colors.white,
            ),
            notifiedIcon: Image.asset(
              "assets/images/notify_check.png",
              color: Colors.white,
              width: 14,
              height: 14,
            ),
          );
        });
      },
    );
  }

  Widget _buildTechCommunitiesSection() {
    // This can be adapted to use `controller.gadgetData.value.communities` if you populate it
    final List<Map<String, String>> communities = [
      {
        "id": "android_devs",
        "name": "Android Devs Global",
        "desc": "Kotlin & Flutter discussions",
        "imageUrl": "https://placehold.co/40x40/D9D9D9/000?text=ADG",
      },
      {
        "id": "pc_masters",
        "name": "PC Master Race",
        "desc": "Builds, benchmarks, & more",
        "imageUrl": "https://placehold.co/40x40/D9D9D9/000?text=PCMR",
      },
    ];

    return HorizontalCardList<Map<String, String>>(
      title: 'EXPLORE TECH COMMUNITIES',
      items: communities,
      listHeight: 120,
      cardBuilder: (context, community) {
        return CommunityCard(
          name: community['name']!,
          description: community['desc']!,
          imageUrl: community['imageUrl']!,
          accentColor: gadgetAccentColor,
          onJoin: () {
            Get.to(
              () => FeaturesScreenCommunity(
                communityId: community['id']!,
                communityName: community['name']!,
                communityImageUrl: community['imageUrl']!,
              ),
            );
          },
          buttonIcon: Image.asset(
            width: 14,
            height: 14,
            "assets/images/pepole.png",
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildGadgetSurveySection() {
    final gadgetSurvey = Survey(
      id: 'phone_os_survey',
      question: 'What is your primary mobile operating system?',
      options: [
        SurveyOption(id: 'os_android', text: "Android"),
        SurveyOption(id: 'os_ios', text: "iOS"),
        SurveyOption(id: 'os_other', text: "Other"),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle('SURVEY'),
          const SizedBox(height: 10),
          // --- Corrected SurveyCard call for Gadgets ---
          SurveyCard(
            survey: gadgetSurvey,
            accentColor: gadgetAccentColor, // Use the correct accent color
            onSubmit: (String selectedOptionId) {
              print(
                "Gadget Survey submitted! Selected option ID: $selectedOptionId",
              );
              // You can add more specific logic here if needed
            },
            filledButtonBuilder: (text, {background, onTap}) {
              return filledButton(
                text,
                background: background ?? gadgetAccentColor,
                onTap: onTap,
                fontSize: 12,
              );
            },
          ),
        ],
      ),
    );
  }

  /// --------------------------------------

  Widget buildBooksTab() {
    return Obx(() {
      final bookData = controller.bookData.value;
      if (controller.isLoadingBooks.value && bookData.featured.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(bookAccentColor),
          ),
        );
      }

      return ListView(
       // padding: const EdgeInsets.only(top: 12, bottom: 24),
        children: [
          if (bookData.featured.isNotEmpty)
            ReusableCarousel<BookModel>(
              context,
              items: bookData.featured.obs,
              controller: controller,
              cardBuilder: (book) {
                return FeaturedContentCardLarge(
                  imageUrl: book.imageUrl,
                  title: book.title,
                  infoItems: [
                    book.author,
                    ...book.genres,
                  ].where((s) => s.isNotEmpty).toList(),
                  rating: book.rating?.toStringAsFixed(1) ?? 'N/A',
                  votes: "${book.votes ?? '0'} Votes",
                  ratingIcon: Image.asset(
                    "assets/images/book.png",
                    width: 14,
                    height: 14,
                    color: bookAccentColor,
                  ),
                  accentColor: bookAccentColor,
                  onMoreInfo: () {
                    _showMoreInfoBottomSheet(
                      title: book.title,
                      rating: book.rating?.toStringAsFixed(1) ?? "N/A",
                      votes: book.votes ?? "0 Votes",
                      infoItems: book.genres,
                      description:
                          book.description ?? "A new book by ${book.author}.",
                      accentColor: bookAccentColor,
                      ratingIconAsset: "assets/images/book.png",
                      onPrimaryButtonTap: () =>
                          Get.to(() => MainReviewScreenBooks(bookId: book.id)),
                      itemId: book.id,
                    );
                  },
                  onViewAllReviews: () =>
                      Get.to(() => MainReviewScreenBooks(bookId: book.id)),
                  itemId: book.id,
                );
              },
            ),

          _buildFeaturedBooksSection(),
          _buildTrendingBooksSection(bookData.trending),
          _buildUpcomingBooksSection(),
          _buildBookClubsSection(),
          _buildBookSurveySection(),
          const SizedBox(height: 20),
        ],
      );
    });
  }

  Widget _buildTrendingBooksSection(List<BookModel> trendingBooks) {
    if (trendingBooks.isEmpty) return const SizedBox.shrink();

    // Convert the list to a reactive RxList for the carousel.
    final RxList<BookModel> trendingBooksRx = trendingBooks.obs;

    return TrendingCarousel<BookModel>(
      context: context, // Pass context directly to the carousel
      items: trendingBooksRx,
      cardBuilder: (book) {
        // The cardBuilder now only takes the item.
        final details = [
          book.author,
          ...book.genres,
        ].where((s) => s.isNotEmpty).join(' • ');

        return TrendingCard(
          imageUrl: book.imageUrl,
          title: book.title,
          details: details,
          starnestRating: book.rating?.toStringAsFixed(1) ?? "N/A",
          audienceRating: "4.7", // Placeholder, adjust as needed
          audienceVotes: book.votes ?? "0 votes",
          ratingImage: Image.asset(
            "assets/images/book.png",
            width: 14,
            height: 14,
            color: bookAccentColor,
          ),
          exploreButtonImage: Image.asset(
            "assets/images/book.png",
            width: 14,
            height: 14,
            color: Colors.white,
          ),
          exploreButtonImageColor: bookAccentColor,
          onExplore: () {
            print("Explore tapped for ${book.title}");
            Get.to(() => MainReviewScreenBooks(bookId: book.id));
          },
          onWriteReview: () {
            Get.to(
              () => AddEditReviewScreen(
                itemName: book.title,
                itemType: "Book",
                accentColor: bookAccentColor,
                ratingAssetPath: "assets/images/book.png",
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFeaturedBooksSection() {
    final featuredBooks = controller.bookData.value.featured;
    if (featuredBooks.isEmpty) return const SizedBox.shrink();

    return HorizontalCardList<BookModel>(
      title: 'FEATURED BOOKS',
      items: featuredBooks,
      cardBuilder: (context, book) {
        return FeaturedContentCard(
          imageUrl: book.imageUrl,
          title: book.title,
          rating: book.rating?.toStringAsFixed(1),
          ratingIconAsset: "assets/images/book.png",
          activeRatingIconColor: bookAccentColor,
          inactiveRatingIconColor: Colors.white,
          onTap: () {
            print("Explore tapped for ${book.title}");
            Get.to(() => MainReviewScreenBooks(bookId: book.id));
          },
        );
      },
    );
  }

  Widget _buildUpcomingBooksSection() {
    final List<Map<String, String>> upcomingItems = [
      {
        "id": "stormlight_5",
        "title": "Winds and Truth",
        "details": "Brandon Sanderson, Epic Fantasy",
        "releaseDate": "6 Dec, 2024",
        "imageUrl":
            "https://placehold.co/300x400/141414/ffffff?text=Stormlight+5",
      },
    ];
    return HorizontalCardList<Map<String, String>>(
      title: 'UPCOMING BOOKS',
      items: upcomingItems,
      listHeight: 320,
      cardBuilder: (context, item) {
        final String itemId = item["id"]!;
        return Obx(() {
          final bool isNotified = controller.isUpcomingMovieNotified(itemId);
          return UpcomingContentCard(
            id: itemId,
            title: item['title']!,
            imageUrl: item['imageUrl']!,
            details: item['details']!,
            releaseDate: item['releaseDate']!,
            isNotified: isNotified,
            accentColor: bookAccentColor,
            onNotifyToggle: () =>
                controller.toggleUpcomingMovieNotification(itemId),
            onExplore: () {
              print("Explore tapped for ${item['title']}");
              Get.to(() => MainReviewScreenBooks(bookId: itemId));
            },
            infoIcon: const Icon(
              Icons.info_outline,
              size: 16,
              color: bookAccentColor,
            ),
            notifyIcon: Image.asset(
              width: 14,
              height: 14,
              "assets/images/notification.png",
              color: Colors.white,
            ),
            notifiedIcon: Image.asset(
              "assets/images/notify_check.png",
              color: Colors.white,
              width: 14,
              height: 14,
            ),
          );
        });
      },
    );
  }

  Widget _buildBookClubsSection() {
    final List<Map<String, String>> communities = [
      {
        "id": "fantasy_readers",
        "name": "Fantasy Readers Guild",
        "desc": "High fantasy & epic tales",
        "imageUrl": "https://placehold.co/40x40/D9D9D9/000?text=FRG",
      },
      {
        "id": "nonfic_nerds",
        "name": "Non-Fiction Nerds",
        "desc": "Biographies, history, science",
        "imageUrl": "https://placehold.co/40x40/D9D9D9/000?text=NFN",
      },
    ];

    return HorizontalCardList<Map<String, String>>(
      title: 'EXPLORE BOOK CLUBS',
      items: communities,
      listHeight: 120,
      cardBuilder: (context, community) {
        return CommunityCard(
          name: community['name']!,
          description: community['desc']!,
          imageUrl: community['imageUrl']!,
          accentColor: bookAccentColor,
          onJoin: () {
            Get.to(
              () => FeaturesScreenCommunity(
                communityId: community['id']!,
                communityName: community['name']!,
                communityImageUrl: community['imageUrl']!,
              ),
            );
          },
          buttonIcon: Image.asset(
            width: 14,
            height: 14,
            "assets/images/pepole.png",
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildBookSurveySection() {
    final bookSurvey = Survey(
      id: 'reading_format_survey',
      question: 'How do you prefer to read?',
      options: [
        SurveyOption(id: 'read_physical', text: "Physical Books"),
        SurveyOption(id: 'read_ebook', text: "E-Books / Kindle"),
        SurveyOption(id: 'read_audio', text: "Audiobooks"),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle('SURVEY'),
          const SizedBox(height: 10),
          // --- Corrected SurveyCard call for Books ---
          SurveyCard(
            survey: bookSurvey,
            accentColor: bookAccentColor, // Use the correct accent color
            onSubmit: (String selectedOptionId) {
              print(
                "Book Survey submitted! Selected option ID: $selectedOptionId",
              );
            },
            filledButtonBuilder: (text, {background, onTap}) {
              return filledButton(
                text,
                background: background ?? bookAccentColor,
                onTap: onTap,
                fontSize: 12,
              );
            },
          ),
        ],
      ),
    );
  }

  /// --------------------------------------

  Widget buildGamesTab() {
    return Obx(() {
      final gameData = controller.gameData.value;
      if (controller.isLoadingGames.value && gameData.featured.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(gameAccentColor),
          ),
        );
      }

      return ListView(
       // padding: const EdgeInsets.only(top: 12, bottom: 24),
        children: [
          if (gameData.featured.isNotEmpty)
            ReusableCarousel<GameModel>(
              context,
              items: gameData.featured.obs,
              controller: controller,
              cardBuilder: (game) {
                return FeaturedContentCardLarge(
                  imageUrl: game.imageUrl,
                  title: game.title,
                  infoItems: [
                    game.developer,
                    ...game.genres,
                  ].where((s) => s.isNotEmpty).toList(),
                  rating: game.rating?.toStringAsFixed(1) ?? 'N/A',
                  votes: "${game.votes ?? '0'} Votes",
                  ratingIcon: Image.asset(
                    "assets/images/games.png",
                    width: 14,
                    height: 14,
                    color: gameAccentColor,
                  ),
                  accentColor: gameAccentColor,
                  onMoreInfo: () {
                    _showMoreInfoBottomSheet(
                      title: game.title,
                      rating: game.rating?.toStringAsFixed(1) ?? "N/A",
                      votes: game.votes ?? "0 Votes",
                      infoItems: game.genres,
                      description:
                          game.description ??
                          "A new game from ${game.developer}.",
                      accentColor: gameAccentColor,
                      ratingIconAsset: "assets/images/games.png",
                      onPrimaryButtonTap: () =>
                          Get.to(() => MainReviewScreenGames(gameId: game.id)),
                      itemId: game.id,
                    );
                  },
                  onViewAllReviews: () =>
                      Get.to(() => MainReviewScreenGames(gameId: game.id)),
                  itemId: game.id,
                );
              },
            ),
          _buildFeaturedGamesSection(),
          _buildTrendingGamesSection(gameData.trending),
          _buildUpcomingGamesSection(),
          _buildGamingClansSection(),
          _buildGameSurveySection(),
          _buildDiscordServersSection(),
          const SizedBox(height: 20),
        ],
      );
    });
  }
  Widget _buildDiscordServersSection() {
    final List<Map<String, String>> discordServers = [
      {
        "id": "ds1",
        "name": "GTA VI",
        "desc": "Official GTA Community",
        "imageUrl": "https://placehold.co/40x40/141414/ffffff?text=GTA",
      },
      {
        "id": "ds2",
        "name": "PUBG Mobile",
        "desc": "Rank push squad",
        "imageUrl": "https://placehold.co/40x40/141414/ffffff?text=PUBG",
      },
      {
        "id": "ds3",
        "name": "Warzone",
        "desc": "Call of Duty updates",
        "imageUrl": "https://placehold.co/40x40/141414/ffffff?text=COD",
      },
      {
        "id": "ds4",
        "name": "Minecraft",
        "desc": "Survival & Creative",
        "imageUrl": "https://placehold.co/40x40/141414/ffffff?text=MC",
      },
    ];

    return DiscordSection(servers: discordServers);
  }

  Widget _buildTrendingGamesSection(List<GameModel> trendingGames) {
    if (trendingGames.isEmpty) return const SizedBox.shrink();

    // Convert the list to a reactive RxList for the carousel.
    final RxList<GameModel> trendingGamesRx = trendingGames.obs;

    return TrendingCarousel<GameModel>(
      context: context, // Pass context directly to the carousel
      items: trendingGamesRx,
      cardBuilder: (game) {
        // The cardBuilder now only takes the item.
        final details = [
          game.developer,
          ...game.genres,
        ].where((s) => s.isNotEmpty).join(' • ');
        return TrendingCard(
          imageUrl: game.imageUrl,
          title: game.title,
          details: details,
          starnestRating: game.rating?.toStringAsFixed(1) ?? "N/A",
          audienceRating: "4.9",
          audienceVotes: game.votes ?? "0",
          ratingImage: Image.asset(
            "assets/images/games.png",
            width: 14,
            height: 14,
            color: gameAccentColor,
          ),
          exploreButtonImage: Image.asset(
            "assets/images/games.png",
            width: 14,
            height: 14,
            color: Colors.white,
          ),
          exploreButtonImageColor: gameAccentColor,
          tvbutton1: "Review",
          tvbutton2: "Details",
          onExplore: () {
            print("Explore tapped for ${game.title}");
            Get.to(() => MainReviewScreenGames(gameId: game.id));
          },
          onWriteReview: () {
            Get.to(
              () => AddEditReviewScreen(
                itemName: game.title,
                itemType: "Game",
                accentColor: gameAccentColor,
                ratingAssetPath: "assets/images/games.png",
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFeaturedGamesSection() {
    final featuredGames = controller.gameData.value.featured;
    if (featuredGames.isEmpty) return const SizedBox.shrink();
    return HorizontalCardList<GameModel>(
      title: 'FEATURED GAMES',
      items: featuredGames,
      cardBuilder: (context, game) {
        return FeaturedContentCard(
          imageUrl: game.imageUrl,
          title: game.title,
          rating: game.rating?.toStringAsFixed(1),
          ratingIconAsset: "assets/images/games.png",
          activeRatingIconColor: gameAccentColor,
          inactiveRatingIconColor: Colors.white,
          onTap: () {
            print("Explore tapped for ${game.title}");
            // Get.to(() => GameReviewScreen(itemId: game.id));
          },
        );
      },
    );
  }

  Widget _buildUpcomingGamesSection() {
    final List<Map<String, String>> upcomingItems = [
      {
        "id": "gta_6",
        "title": "GTA VI",
        "details": "Rockstar Games, Open World",
        "releaseDate": "Fall 2025",
        "imageUrl": "https://placehold.co/300x400/141414/ffffff?text=GTA+VI",
      },
      {
        "id": "wolverine_ps5",
        "title": "Wolverine",
        "details": "Insomniac, Action-Adventure",
        "releaseDate": "TBA 2026",
        "imageUrl": "https://placehold.co/300x400/141414/ffffff?text=Wolverine",
      },
    ];
    return HorizontalCardList<Map<String, String>>(
      title: 'UPCOMING GAMES',
      items: upcomingItems,
      listHeight: 320,
      cardBuilder: (context, item) {
        final String itemId = item["id"]!;
        return Obx(() {
          final bool isNotified = controller.isUpcomingMovieNotified(itemId);
          return UpcomingContentCard(
            id: itemId,
            title: item['title']!,
            imageUrl: item['imageUrl']!,
            details: item['details']!,
            releaseDate: item['releaseDate']!,
            isNotified: isNotified,
            accentColor: gameAccentColor, // Use correct color
            onNotifyToggle: () =>
                controller.toggleUpcomingMovieNotification(itemId),
            onExplore: () => print("Explore tapped for ${item['title']}"),
            infoIcon: const Icon(
              Icons.info_outline,
              size: 16,
              color: gameAccentColor,
            ),
            notifyIcon: Image.asset(
              width: 14,
              height: 14,
              "assets/images/notification.png",
              color: Colors.white,
            ),
            notifiedIcon: Image.asset(
              "assets/images/notify_check.png",
              color: Colors.white,
              width: 14,
              height: 14,
            ),
          );
        });
      },
    );
  }

  Widget _buildGamingClansSection() {
    final List<Map<String, String>> communities = [
      {
        "id": "valorant_pros",
        "name": "Valorant Pros",
        "desc": "Rank pushing & strategy",
        "imageUrl": "https://placehold.co/40x40/D9D9D9/000?text=VP",
      },
      {
        "id": "rpg_central",
        "name": "RPG Central",
        "desc": "All things role-playing",
        "imageUrl": "https://placehold.co/40x40/D9D9D9/000?text=RPGC",
      },
    ];
    return HorizontalCardList<Map<String, String>>(
      title: 'EXPLORE GAMING CLANS',
      items: communities,
      listHeight: 120,
      cardBuilder: (context, community) {
        return CommunityCard(
          name: community['name']!,
          description: community['desc']!,
          imageUrl: community['imageUrl']!,
          accentColor: gameAccentColor,
          onJoin: () {
            Get.to(
              () => FeaturesScreenCommunity(
                communityId: community['id']!,
                communityName: community['name']!,
                communityImageUrl: community['imageUrl']!,
              ),
            );
          },
          buttonIcon: Image.asset(
            width: 14,
            height: 14,
            "assets/images/pepole.png",
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildGameSurveySection() {
    final gameSurvey = Survey(
      id: 'platform_survey',
      question: 'Which is your primary gaming platform?',
      options: [
        SurveyOption(id: 'plat_pc', text: "PC"),
        SurveyOption(id: 'plat_playstation', text: "PlayStation"),
        SurveyOption(id: 'plat_xbox', text: "Xbox"),
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle('SURVEY'),
          const SizedBox(height: 10),
          SurveyCard(
            survey: gameSurvey,
            accentColor: gameAccentColor,
            onSubmit: (String selectedOptionId) {
              print(
                "Game Survey submitted! Selected option ID: $selectedOptionId",
              );
            },
            filledButtonBuilder: (text, {background, onTap}) {
              return filledButton(
                text,
                background: background ?? gameAccentColor,
                onTap: onTap,
                fontSize: 12,
              );
            },
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildIconNavItem(
    String assetPath,
    String selectedAssetPath,
    int index, {
    double width = 24,
    double height = 24,
    int? dominanceThreshold,
  }) {
    bool isSelected = controller.selectedBottomNavIndex.value == index;
    String currentAssetPath = isSelected ? selectedAssetPath : assetPath;
    Color iconColor = isSelected
        ? controller.currentAccentColor.value
        : controller.currentAccentColor.value;

    return BottomNavigationBarItem(
      icon: TintedAssetImage(
        assetPath: currentAssetPath,
        targetColor: iconColor,
        dominanceThreshold: dominanceThreshold,
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
      label: '',
    );
  }

  Widget _buildHomeContent() {
    return TabContainer(
      controller: _tabController,
      children: controller.categories.map((category) {
        switch (category) {
          case "Movies":
            return buildMoviesTab();
          case "Restaurants":
            return buildRestaurantsTab();
          case "Gadgets":
            return buildGadgetsTab();
          case "Books":
            return buildBooksTab();
          case "Games":
            return buildGamesTab();
          default:
            return Center(
              child: Text(
                "Content for $category",
                style: const TextStyle(
                  color: primaryTextColor,
                  fontFamily: 'General Sans Variable',
                  fontSize: 20,
                ),
              ),
            );
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.selectedBottomNavIndex.value != 0) {
          controller.selectedBottomNavIndex.value = 0;
          return false;
        }
        return true;
      },
      child: Obx(() {
        final isHomeScreen = controller.selectedBottomNavIndex.value == 0;
        final Color currentAccentColor = controller.currentAccentColor.value;

        return Scaffold(
          backgroundColor: isHomeScreen ? currentAccentColor : Colors.white,
          appBar: isHomeScreen
              ? AppBar(
                  backgroundColor: currentAccentColor,
                  elevation: 0,
                  titleSpacing: 16.0,
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/images/black_logo.png',
                        height: 22,
                        width: 22,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Gachibowli\nHyderabad",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'General Sans Variable',
                          height: 1.2, // Added for better line spacing
                        ),
                      ),
                    ],
                  ),
 actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Center(
                        child: Image.asset('assets/images/location.png'),
                      ),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48),
                    child: Container(
                      clipBehavior: Clip.none,
                      padding: const EdgeInsets.only(left: 10, right: 10, ),
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        indicatorPadding:  EdgeInsets.zero,
                        tabAlignment: TabAlignment.start,
                        indicator: const BubbleTabIndicator(),
                        dividerColor: Colors.transparent,
                        labelColor: currentAccentColor,
                        unselectedLabelColor: Colors.black,
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'General Sans Variable',
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'General Sans Variable',
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: controller.categories
                            .map((category) => Tab(text: category, height: 28))
                            .toList(),
                      ),
                    ),
                  ),
                )
              : null,
            body: Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Color(0xFF0B0B0B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(17),
                  topRight: Radius.circular(20),
                ),
              ),
              child: IndexedStack(
              index: controller.selectedBottomNavIndex.value,
              children: _pages,),
            ),

          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: cardBackgroundColor,
            currentIndex: controller.selectedBottomNavIndex.value,
            onTap: (index) => controller.selectedBottomNavIndex.value = index,
            selectedItemColor: currentAccentColor,
            unselectedItemColor: currentAccentColor,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              _buildIconNavItem(
                "assets/images/home_unselect.png",
                "assets/images/home.png", // Selected icon for Home
                0,
              ),
              _buildIconNavItem(
                "assets/images/chat_unselect.png",
                "assets/images/chat_select.png", // Selected icon for Add
                1,
              ),
              _buildIconNavItem(
                "assets/images/search_ai_unselect.png",
                "assets/images/search_ai_select.png", // Selected icon for Search
                2,
                dominanceThreshold: 30, // reduce threshold to recolor more pixels as blue
              ),
              _buildIconNavItem(
                "assets/images/notification.png",
                "assets/images/notification_select.png", // Selected icon for Notify
                3,
              ),
              _buildIconNavItem(
                "assets/images/profile.png",
                "assets/images/people_select.png", // Selected icon for Profile
                4,
              ),
            ],
          ),
        );
      }),
    );
  }
  void _showCommunityJoinSheet(Map<String, String> community) {
    Get.bottomSheet(
      CommunityJoinBottomSheet(
        communityId: community['id']!,
        communityName: community['name']!,
        communityImageUrl: "https://placehold.co/375x180/1E1E1E/ffffff?text=${community['name']}",
        communityDescription: community['desc']!,
        memberCount: "1200+ Members", // This can be made dynamic if available
        accentColor: controller.currentAccentColor.value,
        onSendRequest: () {
          Navigator.of(context).pop;
          print("Navigating to community: ${community['name']}");
          Get.to(
                () => FeaturesScreenCommunity(
              communityId: community['id']!,
              communityName: community['name']!,
              communityImageUrl: community['imageUrl']!,
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }


  void _showMoreInfoBottomSheet({
    required String itemId, // Added required itemId
    required String title,
    required String rating,
    required String votes,
    required List<String> infoItems,
    required String description,
    List<ActorInfo> cast = const [],
    Color? accentColor,
    String? ratingIconAsset,
    String? primaryButtonText,
    VoidCallback? onPrimaryButtonTap,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return MoreInfoBottomSheet(
          itemId: itemId, // Pass the itemId
          title: title,
          rating: rating,
          votes: votes,
          infoItems: infoItems,
          description: description,
          cast: cast,
          accentColor: accentColor ?? controller.currentAccentColor.value,
          ratingIconAsset: ratingIconAsset ?? "assets/images/sd.png",
          primaryButtonText: primaryButtonText ?? "View All Reviews",
          onPrimaryButtonTap: onPrimaryButtonTap,
          // secondaryButton... properties are removed here as well
        );
      },
    );
  }
}
class BubbleTabIndicator extends Decoration {
  const BubbleTabIndicator();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _BubblePainter(this);
  }
}

class _BubblePainter extends BoxPainter {
  final BubbleTabIndicator decoration;

  _BubblePainter(this.decoration);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Rect baseRect = offset & cfg.size!;
    final Paint paint = Paint()
      ..color = const Color(0xFF0B0B0B)
      ..style = PaintingStyle.fill;

    const double topRadius = 15.0;
    const double concaveRadius = 10.0;

    // Change this value to add horizontal space inside the tab bubble
    const double paddingX = 6.0;

    // We expand the rect slightly downwards to cover any gap between the tab
    // and the body container, and expand horizontally by paddingX.
    final Rect rect = Rect.fromLTRB(
      baseRect.left - paddingX,
      baseRect.top,
      baseRect.right + paddingX,
      baseRect.bottom + 2.0,
    );

    final Path path = Path();

    // 1. Start at bottom-left, outside the tab
    path.moveTo(rect.left - concaveRadius, rect.bottom);

    // 2. Draw the concave curve (bottom-left corner smoothing)
    path.quadraticBezierTo(
      rect.left, rect.bottom,
      rect.left, rect.bottom - concaveRadius,
    );

    // 3. Draw line up to top-left roundness
    path.lineTo(rect.left, rect.top + topRadius);

    // 4. Draw top-left rounded corner
    path.quadraticBezierTo(
      rect.left, rect.top,
      rect.left + topRadius, rect.top,
    );

    // 5. Draw top horizontal line
    path.lineTo(rect.right - topRadius, rect.top);

    // 6. Draw top-right rounded corner
    path.quadraticBezierTo(
      rect.right, rect.top,
      rect.right, rect.top + topRadius,
    );

    // 7. Draw line down to bottom-right curve start
    path.lineTo(rect.right, rect.bottom - concaveRadius);

    // 8. Draw the concave curve (bottom-right corner smoothing)
    path.quadraticBezierTo(
      rect.right, rect.bottom,
      rect.right + concaveRadius, rect.bottom,
    );

    // 9. Close the shape at the bottom
    path.lineTo(rect.left - concaveRadius, rect.bottom);

    path.close();
    canvas.drawPath(path, paint);
  }
}

class TabContainer extends StatelessWidget {
  final TabController? controller;
  final List<Widget> children;

  const TabContainer({super.key, this.controller, required this.children});

  @override
  Widget build(BuildContext context) {
    return TabBarView(controller: controller, children: children);
  }
}
