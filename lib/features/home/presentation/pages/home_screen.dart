import 'dart:math' show min;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starnest/features/notification/presentation/pages/notification_screen.dart';
import 'package:starnest/features/profile/presentation/pages/profile_screen.dart';
import 'package:starnest/features/search/presentation/pages/search_screen.dart';
import 'package:starnest/core/tracking/starnest_tracker.dart';
import 'package:starnest/features/community/presentation/pages/joined_community_list_screen.dart';
import 'package:starnest/features/community/presentation/organisms/community_join_bottom_sheet.dart';
import 'package:starnest/features/home/presentation/organisms/more_info_bottom_sheet.dart';
import 'package:starnest/features/home/data/models/book_model.dart';
import 'package:starnest/features/home/data/models/gadget_model.dart';
import 'package:starnest/features/home/data/models/game_model.dart';
import 'package:starnest/features/home/data/models/restaurant_model.dart';
import 'package:starnest/features/home/presentation/organisms/trending_card.dart';
import 'package:starnest/features/home/presentation/organisms/community_card.dart';
import 'package:starnest/features/home/presentation/organisms/featured_card.dart';
import 'package:starnest/features/home/presentation/organisms/survey_card.dart';
import 'package:starnest/features/home/presentation/molecules/trending_section.dart';
import 'package:starnest/features/home/presentation/molecules/upcoming_section.dart';
import 'package:starnest/features/home/presentation/organisms/featured_content_card_large.dart';
import 'package:starnest/features/home/presentation/molecules/horizontal_card_list.dart';
import 'package:starnest/features/home/presentation/molecules/reusable_carousel.dart';
import 'package:starnest/features/home/presentation/atoms/build_section_title.dart';
import 'package:starnest/features/home/presentation/atoms/filled_button.dart';
import 'package:starnest/features/review/presentation/pages/main_review_screen_books.dart';
import 'package:starnest/features/review/presentation/pages/main_review_screen_gadgets.dart';
import 'package:starnest/features/review/presentation/pages/main_review_screen_games.dart';
import 'package:starnest/features/review/presentation/pages/main_review_screen_movies.dart';
import 'package:starnest/features/chat/presentation/pages/features_screen_community.dart';
import 'package:starnest/features/review/presentation/pages/main_review_screen_restaurants.dart';
import 'package:starnest/features/review/presentation/pages/add_edit_review_screen.dart';
import 'package:starnest/features/home/presentation/controllers/home_controller.dart';
import 'package:starnest/features/home/data/models/movie_model.dart';
import 'package:starnest/ui/atoms/tinted_asset_image.dart';

import 'package:starnest/features/home/presentation/organisms/discord_section.dart';

const Color movieAccentColor = Color(0xFF54B6E0);
const Color darkBackgroundColor = Color(0xFF0B0B0B);
const Color cardBackgroundColor = Color(0xFF141414);
const Color secondaryTextColor = Color(0xFF626365);
const Color primaryTextColor = Colors.white;
const Color gameAccentColor = Color(0xFF90BE6D);
const Color bookAccentColor = Color(0xFFCDBBE9);
const Color gadgetAccentColor = Color(0xFFE45659);

class HomeScreen extends StatefulWidget {
  final TabController tabController;
  const HomeScreen({super.key, required this.tabController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.find<HomeController>();
  TabController get _tabController => widget.tabController;
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
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_tabListener);
    _nowShowingPageController = PageController(viewportFraction: 0.92);
    _trendingScrollController.addListener(_trendingScrollListener);
  }

  void _tabListener() {
    if (!widget.tabController.indexIsChanging) {
      StarNestTracker.instance.trackTagClick(tagId: controller.categories[widget.tabController.index]);
    }
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_tabListener);
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
      return ListView(
      //  padding: listViewPadding,
        children: [
          if (movieData.featured.isNotEmpty)
            ReusableCarousel<MovieModel>(
              context,
              items: movieData.featured.obs,
              controller: controller,
              cardBuilder: (movie, index) {
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
                    StarNestTracker.instance.trackView(
                      module: 'movies/movie',
                      itemId: movie.id,
                    );
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
                    StarNestTracker.instance.trackClick(
                      module: 'movies/movie',
                      itemId: movie.id,
                      section: 'featured_carousel',
                      position: index,
                    );
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
  return Obx(() {
    final featuredMovies = controller.movieData.value.featured;

    if (featuredMovies.isEmpty) {
      return const SizedBox.shrink();
    }

    return HorizontalCardList<MovieModel>(
      title: 'FEATURED MOVIES',
      items: featuredMovies,
      cardBuilder: (context, movie, index) {
        return FeaturedContentCard(
          imageUrl: movie.imageUrl,
          title: movie.title,
          rating: movie.rating.toStringAsFixed(1),
          ratingIconAsset: "assets/images/sd.png",
          activeRatingIconColor: movieAccentColor,
          inactiveRatingIconColor: Colors.white,
          onTap: () {
            StarNestTracker.instance.trackClick(
              module: 'movies/movie',
              itemId: movie.id,
              section: 'featured_list',
              position: index,
            );
            Get.to(
              () => MainReviewScreenMovies(
                movieId: movie.id,
              ),
            );
          },
        );
      },
    );
  });
}

  Widget _buildNewTrendingSection() {
  return Obx(() {
    final trendingMovies = controller.movieData.value.trending;

    if (trendingMovies.isEmpty) {
      return const SizedBox.shrink();
    }

    return TrendingCarousel<MovieModel>(
      context: context,
      items: trendingMovies.obs,
      cardBuilder: (movie, index) {
        final details = [
          movie.duration,
          movie.certification,
          movie.language,
        ].join(' • ');

        return TrendingCard(
          imageUrl: movie.imageUrl,
          title: movie.title,
          details: details,
          starnestRating: movie.rating.toStringAsFixed(1),
          audienceRating: movie.rating.toStringAsFixed(1),
          audienceVotes: "${movie.votes} Votes",
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
            StarNestTracker.instance.trackClick(
              module: 'movies/movie',
              itemId: movie.id,
              section: 'trending_carousel',
              position: index,
            );
            Get.to(
              () => MainReviewScreenMovies(
                movieId: movie.id,
              ),
            );
          },

          onWriteReview: () {
            Get.to(
              () => AddEditReviewScreen(
                itemName: movie.title,
                itemType: "Movie",
                accentColor: movieAccentColor,
                ratingAssetPath: "assets/images/sd.png",
              ),
            );
          },
        );
      },
    );
  });
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
      cardBuilder: (context, movie, index) {
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
              // ✅ FIXED: Added navigation to Movie Review Screen
              StarNestTracker.instance.trackClick(
                module: 'movies/movie',
                itemId: movieId,
                section: 'upcoming_releases',
                position: index,
              );
              Get.to(() => MainReviewScreenMovies(movieId: movieId));
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
      cardBuilder: (context, community, index) {
        return Obx(() {
          return CommunityCard(
            name: community['name']!,
            description: community['desc']!,
            imageUrl: community['imageUrl']!,
            accentColor: controller.currentAccentColor.value,
            onJoin: () {
              print("Joining community: ${community['name']}");
              StarNestTracker.instance.trackTagClick(tagId: community['id']!);
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
                StarNestTracker.instance.trackSearch(query: 'survey_option: $selectedOptionId');
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
              cardBuilder: (restaurant, index) {
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
                    StarNestTracker.instance.trackView(
                      module: 'movies/movie',
                      itemId: restaurant.id,
                    );
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
  return Obx(() {
    final featuredRestaurants =
        controller.restaurantData.value.featured;

    if (featuredRestaurants.isEmpty) {
      return const SizedBox.shrink();
    }

    return HorizontalCardList<RestaurantModel>(
      title: 'FEATURED RESTAURANTS',
      items: featuredRestaurants,
      cardBuilder: (context, restaurant, index) {
        return FeaturedContentCard(
          imageUrl: restaurant.imageUrl,
          title: restaurant.name,
          rating: restaurant.rating.toStringAsFixed(1),
          ratingIconAsset: "assets/images/restaurants.png",
          activeRatingIconColor: restaurantAccentColor,
          inactiveRatingIconColor: Colors.white,
          onTap: () {
            print("Explore tapped for ${restaurant.name}");

            Get.to(
              () => RestaurantReviewScreen(
                itemId: restaurant.id,
              ),
            );
          },
        );
      },
    );
  });
}

  Widget _buildTrendingRestaurantsSection() {
  return Obx(() {
    final trendingRestaurants =
        controller.restaurantData.value.trending;

    if (trendingRestaurants.isEmpty) {
      return const SizedBox.shrink();
    }

    return TrendingCarousel<RestaurantModel>(
      context: context,
      items: trendingRestaurants.obs,

      cardBuilder: (restaurant, index) {
        final details = [
          restaurant.cuisineType,
          restaurant.address,
        ]
            .where((e) => e != null && e.isNotEmpty)
            .join(' • ');

        return TrendingCard(
          imageUrl: restaurant.imageUrl,
          title: restaurant.name,
          details: details,

          starnestRating:
              restaurant.rating.toStringAsFixed(1),

          audienceRating:
              restaurant.rating.toStringAsFixed(1),

          audienceVotes: "Popular",

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

          exploreButtonImageColor:
              restaurantAccentColor,

          onExplore: () {
            print(
              "Explore tapped for ${restaurant.name}",
            );

            Get.to(
              () => RestaurantReviewScreen(
                itemId: restaurant.id,
              ),
            );
          },

          onWriteReview: () {
            Get.to(
              () => AddEditReviewScreen(
                itemName: restaurant.name,
                itemType: "Restaurant",
                accentColor: restaurantAccentColor,
                ratingAssetPath:
                    "assets/images/restaurants.png",
              ),
            );

            print(
              "Write Review for ${restaurant.name}",
            );
          },
        );
      },
    );
  });
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
      cardBuilder: (context, item, index) {
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
      cardBuilder: (context, community, index) {
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
                StarNestTracker.instance.trackSearch(query: 'survey_option: $selectedOptionId');
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

    if (controller.isLoadingGadgets.value &&
        gadgetData.featured.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(
            gadgetAccentColor,
          ),
        ),
      );
    }

    return ListView(
      children: [

        // ✅ Carousel → Featured
        if (gadgetData.featured.isNotEmpty)
          ReusableCarousel<GadgetModel>(
            context,
            items: gadgetData.featured.obs,
            controller: controller,

            cardBuilder: (gadget, index) {
              return FeaturedContentCardLarge(
                imageUrl: gadget.imageUrl,

                title: gadget.name,

                infoItems: [
                  gadget.brand,
                  ...gadget.keyFeatures.take(3),
                ]
                    .where((s) => s.isNotEmpty)
                    .toList(),

                rating:
                    gadget.rating
                        ?.toStringAsFixed(1) ??
                    'N/A',

                votes:
                    "${gadget.votes ?? '0'} Votes",

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

                    rating:
                        gadget.rating
                            ?.toStringAsFixed(1) ??
                        "N/A",

                    votes:
                        gadget.votes ??
                        "0 Votes",

                    infoItems:
                        gadget.keyFeatures,

                    description:
                        gadget.description ??
                        "A brand new gadget from ${gadget.brand}.",

                    accentColor:
                        gadgetAccentColor,

                    ratingIconAsset:
                        "assets/images/gadget.png",

                    onPrimaryButtonTap:
                        () => Get.to(
                              () =>
                                  MainReviewScreenGadgets(
                                gadgetId:
                                    gadget.id,
                              ),
                            ),

                    itemId: gadget.id,
                  );
                },

                onViewAllReviews:
                    () => Get.to(
                          () =>
                              MainReviewScreenGadgets(
                            gadgetId:
                                gadget.id,
                          ),
                        ),

                itemId: gadget.id,
              );
            },
          ),

        // ✅ Featured → Featured API
        _buildFeaturedGadgetsSection(),

        // ✅ Trending → Trending API
        _buildTrendingGadgetsSection(),

        _buildUpcomingGadgetsSection(),

        _buildTechCommunitiesSection(),

        _buildGadgetSurveySection(),

        const SizedBox(height: 20),
      ],
    );
  });
}

  Widget _buildTrendingGadgetsSection() {
  return Obx(() {

    final trendingGadgets =
        controller.gadgetData.value.trending;

    if (trendingGadgets.isEmpty) {
      return const SizedBox.shrink();
    }

    return TrendingCarousel<GadgetModel>(
      context: context,

      items: trendingGadgets.obs,

      cardBuilder: (gadget, index) {

        final details = [
          gadget.brand,
          ...gadget.keyFeatures.take(2),
        ]
            .where((s) => s.isNotEmpty)
            .join(' • ');

        return TrendingCard(
          imageUrl: gadget.imageUrl,

          title: gadget.name,

          details: details,

          starnestRating:
              gadget.rating
                  ?.toStringAsFixed(1) ??
              "N/A",

          audienceRating:
              gadget.rating
                  ?.toStringAsFixed(1) ??
              "N/A",

          audienceVotes:
              "${gadget.votes ?? '0'} Votes",

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

          exploreButtonImageColor:
              gadgetAccentColor,

          onExplore: () {
            print(
              "Explore tapped for ${gadget.name}",
            );

            Get.to(
              () =>
                  MainReviewScreenGadgets(
                gadgetId: gadget.id,
              ),
            );
          },

          onWriteReview: () {
            Get.to(
              () => AddEditReviewScreen(
                itemName: gadget.name,
                itemType: "Gadget",
                accentColor:
                    gadgetAccentColor,
                ratingAssetPath:
                    "assets/images/gadget.png",
              ),
            );
          },
        );
      },
    );
  });
}

  Widget _buildFeaturedGadgetsSection() {
  return Obx(() {

    final featuredGadgets =
        controller.gadgetData.value.featured;

    if (featuredGadgets.isEmpty) {
      return const SizedBox.shrink();
    }

    return HorizontalCardList<GadgetModel>(
      title: 'FEATURED GADGETS',

      items: featuredGadgets,

      cardBuilder: (context, gadget, index) {
        return FeaturedContentCard(
          imageUrl: gadget.imageUrl,

          title: gadget.name,

          rating:
              gadget.rating
                  ?.toStringAsFixed(1),

          ratingIconAsset:
              "assets/images/gadget.png",

          activeRatingIconColor:
              gadgetAccentColor,

          inactiveRatingIconColor:
              Colors.white,

          onTap: () {
            print(
              "Explore tapped for ${gadget.name}",
            );

            Get.to(
              () =>
                  MainReviewScreenGadgets(
                gadgetId: gadget.id,
              ),
            );
          },
        );
      },
    );
  });
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
      cardBuilder: (context, item, index) {
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
      cardBuilder: (context, community, index) {
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

    if (controller.isLoadingBooks.value &&
        bookData.featured.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(
            bookAccentColor,
          ),
        ),
      );
    }

    return ListView(
      children: [

        // ✅ Carousel → Featured
        if (bookData.featured.isNotEmpty)
          ReusableCarousel<BookModel>(
            context,

            items: bookData.featured.obs,

            controller: controller,

            cardBuilder: (book, index) {
              return FeaturedContentCardLarge(
                imageUrl: book.imageUrl,

                title: book.title,

                infoItems: [
                  book.author,
                  ...book.genres.take(3),
                ]
                    .where((s) => s.isNotEmpty)
                    .toList(),

                rating:
                    book.rating
                        ?.toStringAsFixed(1) ??
                    'N/A',

                votes:
                    "${book.votes ?? '0'} Votes",

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

                    rating:
                        book.rating
                            ?.toStringAsFixed(1) ??
                        "N/A",

                    votes:
                        book.votes ??
                        "0 Votes",

                    infoItems: book.genres,

                    description:
                        book.description ??
                        "A new book by ${book.author}.",

                    accentColor:
                        bookAccentColor,

                    ratingIconAsset:
                        "assets/images/book.png",

                    onPrimaryButtonTap:
                        () => Get.to(
                              () =>
                                  MainReviewScreenBooks(
                                bookId: book.id,
                              ),
                            ),

                    itemId: book.id,
                  );
                },

                onViewAllReviews:
                    () => Get.to(
                          () =>
                              MainReviewScreenBooks(
                            bookId: book.id,
                          ),
                        ),

                itemId: book.id,
              );
            },
          ),

        // ✅ Featured Section
        _buildFeaturedBooksSection(),

        // ✅ Trending Section
        _buildTrendingBooksSection(),

        _buildUpcomingBooksSection(),

        _buildBookClubsSection(),

        _buildBookSurveySection(),

        const SizedBox(height: 20),
      ],
    );
  });
}

  Widget _buildTrendingBooksSection() {
  return Obx(() {

    final trendingBooks =
        controller.bookData.value.trending;

    if (trendingBooks.isEmpty) {
      return const SizedBox.shrink();
    }

    return TrendingCarousel<BookModel>(
      context: context,

      items: trendingBooks.obs,

      cardBuilder: (book, index) {

        final details = [
          book.author,
          ...book.genres.take(2),
        ]
            .where((s) => s.isNotEmpty)
            .join(' • ');

        return TrendingCard(
          imageUrl: book.imageUrl,

          title: book.title,

          details: details,

          starnestRating:
              book.rating
                  ?.toStringAsFixed(1) ??
              "N/A",

          audienceRating:
              book.rating
                  ?.toStringAsFixed(1) ??
              "N/A",

          audienceVotes:
              "${book.votes ?? '0'} Votes",

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

          exploreButtonImageColor:
              bookAccentColor,

          onExplore: () {
            print(
              "Explore tapped for ${book.title}",
            );

            Get.to(
              () =>
                  MainReviewScreenBooks(
                bookId: book.id,
              ),
            );
          },

          onWriteReview: () {
            Get.to(
              () => AddEditReviewScreen(
                itemName: book.title,
                itemType: "Book",
                accentColor:
                    bookAccentColor,
                ratingAssetPath:
                    "assets/images/book.png",
              ),
            );
          },
        );
      },
    );
  });
}

  Widget _buildFeaturedBooksSection() {
  return Obx(() {

    final featuredBooks =
        controller.bookData.value.featured;

    if (featuredBooks.isEmpty) {
      return const SizedBox.shrink();
    }

    return HorizontalCardList<BookModel>(
      title: 'FEATURED BOOKS',

      items: featuredBooks,

      cardBuilder: (context, book, index) {
        return FeaturedContentCard(
          imageUrl: book.imageUrl,

          title: book.title,

          rating:
              book.rating
                  ?.toStringAsFixed(1),

          ratingIconAsset:
              "assets/images/book.png",

          activeRatingIconColor:
              bookAccentColor,

          inactiveRatingIconColor:
              Colors.white,

          onTap: () {
            print(
              "Explore tapped for ${book.title}",
            );

            Get.to(
              () =>
                  MainReviewScreenBooks(
                bookId: book.id,
              ),
            );
          },
        );
      },
    );
  });
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
      cardBuilder: (context, item, index) {
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
      cardBuilder: (context, community, index) {
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

    if (controller.isLoadingGames.value &&
        gameData.featured.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(
            gameAccentColor,
          ),
        ),
      );
    }

    return ListView(
      children: [

        // ✅ Carousel → Featured
        if (gameData.featured.isNotEmpty)
          ReusableCarousel<GameModel>(
            context,

            items: gameData.featured.obs,

            controller: controller,

            cardBuilder: (game, index) {
              return FeaturedContentCardLarge(
                imageUrl: game.imageUrl,

                title: game.title,

                infoItems: [
                  game.developer,
                  ...game.genres.take(3),
                  ...game.platforms.take(2),
                ]
                    .where((s) => s.isNotEmpty)
                    .toList(),

                rating:
                    game.rating
                        ?.toStringAsFixed(1) ??
                    'N/A',

                votes:
                    "${game.votes ?? '0'} Votes",

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

                    rating:
                        game.rating
                            ?.toStringAsFixed(1) ??
                        "N/A",

                    votes:
                        game.votes ??
                        "0 Votes",

                    infoItems: [
                      ...game.genres,
                      ...game.platforms,
                    ],

                    description:
                        game.description ??
                        "A new game from ${game.developer}.",

                    accentColor:
                        gameAccentColor,

                    ratingIconAsset:
                        "assets/images/games.png",

                    onPrimaryButtonTap:
                        () => Get.to(
                              () =>
                                  MainReviewScreenGames(
                                gameId: game.id,
                              ),
                            ),

                    itemId: game.id,
                  );
                },

                onViewAllReviews:
                    () => Get.to(
                          () =>
                              MainReviewScreenGames(
                            gameId: game.id,
                          ),
                        ),

                itemId: game.id,
              );
            },
          ),

        // ✅ Featured API
        _buildFeaturedGamesSection(),

        // ✅ Trending API
        _buildTrendingGamesSection(),

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

  Widget _buildTrendingGamesSection() {
  return Obx(() {

    final trendingGames =
        controller.gameData.value.trending;

    if (trendingGames.isEmpty) {
      return const SizedBox.shrink();
    }

    return TrendingCarousel<GameModel>(
      context: context,

      items: trendingGames.obs,

      cardBuilder: (game, index) {

        final details = [
          game.developer,
          ...game.genres.take(2),
          ...game.platforms.take(1),
        ]
            .where((s) => s.isNotEmpty)
            .join(' • ');

        return TrendingCard(
          imageUrl: game.imageUrl,

          title: game.title,

          details: details,

          starnestRating:
              game.rating
                  ?.toStringAsFixed(1) ??
              "N/A",

          audienceRating:
              game.rating
                  ?.toStringAsFixed(1) ??
              "N/A",

          audienceVotes:
              "${game.votes ?? '0'} Votes",

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

          exploreButtonImageColor:
              gameAccentColor,

          tvbutton1: "Review",

          tvbutton2: "Details",

          onExplore: () {
            print(
              "Explore tapped for ${game.title}",
            );

            Get.to(
              () =>
                  MainReviewScreenGames(
                gameId: game.id,
              ),
            );
          },

          onWriteReview: () {
            Get.to(
              () => AddEditReviewScreen(
                itemName: game.title,
                itemType: "Game",
                accentColor:
                    gameAccentColor,
                ratingAssetPath:
                    "assets/images/games.png",
              ),
            );
          },
        );
      },
    );
  });
}

  Widget _buildFeaturedGamesSection() {
  return Obx(() {

    final featuredGames =
        controller.gameData.value.featured;

    if (featuredGames.isEmpty) {
      return const SizedBox.shrink();
    }

    return HorizontalCardList<GameModel>(
      title: 'FEATURED GAMES',

      items: featuredGames,

      cardBuilder: (context, game, index) {
        return FeaturedContentCard(
          imageUrl: game.imageUrl,

          title: game.title,

          rating:
              game.rating
                  ?.toStringAsFixed(1),

          ratingIconAsset:
              "assets/images/games.png",

          activeRatingIconColor:
              gameAccentColor,

          inactiveRatingIconColor:
              Colors.white,

          onTap: () {
            print(
              "Explore tapped for ${game.title}",
            );

            Get.to(
              () =>
                  MainReviewScreenGames(
                gameId: game.id,
              ),
            );
          },
        );
      },
    );
  });
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
      cardBuilder: (context, item, index) {
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
            onExplore: () {
              print("Explore tapped for ${item['title']}");
              // ✅ FIXED: Added navigation to Game Review Screen
              Get.to(() => MainReviewScreenGames(gameId: itemId));
            },
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
      cardBuilder: (context, community, index) {
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
    return _buildHomeContent();
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
