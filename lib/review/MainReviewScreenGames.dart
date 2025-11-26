import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For Get.snackbar (optional)
import 'package:intl/intl.dart';
import 'package:mobilr_app_ui/chat/comments_screen.dart';
import 'package:mobilr_app_ui/home/controllers/home_controller.dart';
import 'package:mobilr_app_ui/review/add_edit_review_screen.dart'; // For date formatting

// --- Data Models (Ideally in separate files) ---
class GameReviewDetails {
  final String id;
  final String title;
  final String imageUrl;
  final String developer;
  final String genre;
  final String releaseYear;
  final double overallRating;
  final String totalVotes;
  final String starnestRatingDisplay;
  final double starnestRatingValue; // e.g., 4.5 out of 5.0 -> 0.9
  final String audienceRatingDisplay;
  final double audienceRatingValue; // e.g., 4.3 out of 5.0 -> 0.86
  final String synopsis;
  final List<String> tags;
  final List<String> photoUrls; // For the gallery
  final List<GameReview> userReviews;

  GameReviewDetails({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.developer,
    required this.genre,
    required this.releaseYear,
    required this.overallRating,
    required this.totalVotes,
    required this.starnestRatingDisplay,
    required this.starnestRatingValue,
    required this.audienceRatingDisplay,
    required this.audienceRatingValue,
    required this.synopsis,
    required this.tags,
    required this.photoUrls,
    required this.userReviews,
  });
}

class GameReview {
  final String id;
  final String userName;
  final DateTime date;
  final double ratingGiven;
  final String reviewTitle;
  final String reviewText;
  final int likes;
  final int dislikes;
  final String? avatarUrl; // Optional

  GameReview({
    required this.id,
    required this.userName,
    required this.date,
    required this.ratingGiven,
    required this.reviewTitle,
    required this.reviewText,
    required this.likes,
    required this.dislikes,
    this.avatarUrl,
  });
}

// --- Theme Colors ---
const Color screenBackgroundColor = Color(0xFF0B0B0B);
const Color appBarColor = Color(0xFF1E1E1E);
const Color cardBgColor = Color(0xFF141414);
const Color primaryTextColor = Colors.white;
const Color secondaryTextColor = Color(0xFF626365);
const Color accentColor = Color(0xFF90BE6D); // Main accent for stars, buttons
const Color ratingBarBackgroundColor = Color(0xFF1E1E1E);
const Color unselectedStarColor = Color(0xFF4B4B4B);

class MainReviewScreenGames extends StatefulWidget {
  final String gameId; // To know which game's reviews to show

  const MainReviewScreenGames({super.key, required this.gameId});

  @override
  State<MainReviewScreenGames> createState() =>
      _MainReviewScreenGamesState();
}

class _MainReviewScreenGamesState extends State<MainReviewScreenGames> {
  late GameReviewDetails _gameDetails;
  bool _isLoading = true;
  int _userGivenRating = 0;

  // --- ADDED: State variables for review list ---
  final int _initialReviewCount = 2;

  // NEW: Map to track user's like/dislike status for each review
  final Map<String, bool?> _reviewInteractionStatus = {};

  @override
  void initState() {
    super.initState();
    _fetchGameReviewDetails();
  }

  Future<void> _fetchGameReviewDetails() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      _gameDetails = GameReviewDetails(
        id: widget.gameId,
        title: 'CYBERPUNK 2077',
        imageUrl: "https://images.unsplash.com/photo-1604145485438-3b56720a44d8?q=80&w=1964&auto=format&fit=crop", // A better placeholder
        developer: "CD PROJEKT RED",
        genre: "Action RPG",
        releaseYear: "2020",
        overallRating: 4.6,
        totalVotes: "2.1M Votes",
        starnestRatingDisplay: "4.7",
        starnestRatingValue: 4.7 / 5.0,
        audienceRatingDisplay: "4.5",
        audienceRatingValue: 4.5 / 5.0,
        synopsis:
        "Cyberpunk 2077 is an open-world, action-adventure story set in Night City, a megalopolis obsessed with power, glamour and body modification. You play as V, a mercenary outlaw going after a one-of-a-kind implant that is the key to immortality.",
        tags: ["RPG", "Open World", "Cyberpunk", "Sci-Fi", "Shooter"],
        photoUrls: [
          "https://placehold.co/327x150/2a2a2c/ffffff?text=Image+1",
          "https://placehold.co/108x100/3a3a3c/ffffff?text=Thumb+1",
          "https://placehold.co/117x108/4a4a4c/ffffff?text=Thumb+2",
          "https://placehold.co/108x100/5a5a5c/ffffff?text=Thumb+3",
        ],
        userReviews: [
          GameReview(id: 'r1', userName: 'GamerX', date: DateTime.now().subtract(const Duration(days: 3)), ratingGiven: 5.0, reviewTitle: 'A True Masterpiece!', reviewText: 'Night City is one of the most immersive open worlds I have ever explored. The story, characters, and gameplay are all top-notch. A must-play for any RPG fan.', likes: 580, dislikes: 12, avatarUrl: "https://placehold.co/40x40/FFC0CB/000?text=GX"),
          GameReview(id: 'r2', userName: 'PixelPioneer', date: DateTime.now().subtract(const Duration(days: 20)), ratingGiven: 4.0, reviewTitle: 'Great game after the patches.', reviewText: 'The game had a rough launch, but CDPR has turned it around. It is now a fantastic experience with a gripping story and incredible world design. Worth a second look.', likes: 415, dislikes: 25, avatarUrl: "https://placehold.co/40x40/ADD8E6/000?text=PP"),
          GameReview(id: 'r3', userName: 'CasualGamer', date: DateTime.now().subtract(const Duration(days: 30)), ratingGiven: 4.5, reviewTitle: 'Incredible world, so much to do!', reviewText: 'I am dozens of hours in and still finding new things to do. The city feels alive and the side quests are just as good as the main story.', likes: 350, dislikes: 8),
        ],
      );
      _isLoading = false;
    });
  }

  // NEW: Method to handle like/dislike logic
  void _handleReviewInteraction(String reviewId, bool isLikeButton) {
    setState(() {
      final currentStatus = _reviewInteractionStatus[reviewId];
      if (isLikeButton) {
        _reviewInteractionStatus[reviewId] = (currentStatus == true) ? null : true;
      } else {
        _reviewInteractionStatus[reviewId] = (currentStatus == false) ? null : false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: screenBackgroundColor,
        body: Center(child: CircularProgressIndicator(color: accentColor)),
      );
    }

    return Scaffold(
      backgroundColor: screenBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildGamePrimaryInfo(),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildRatingsSection(),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSynopsisSection(),
                              const SizedBox(height: 16),
                              _buildTagChips(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildRateThisProductSection(),
                  ),
                ],
              ),
            ),
          ),
          _buildReviewsListHeader(),
          _buildReviewsList(),
          if (_gameDetails.userReviews.length > _initialReviewCount)
            SliverToBoxAdapter(child: _buildViewMoreButton()),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 288.0,
      pinned: true,
      backgroundColor: appBarColor,
      elevation: 2,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: primaryTextColor),
        onPressed: () => Navigator.of(context).pop(),
      ),

      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _gameDetails.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[800],
                  child: const Icon(Icons.error_outline,
                      color: Colors.white24, size: 48)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    screenBackgroundColor.withOpacity(0.5),
                    screenBackgroundColor,
                  ],
                  stops: const [0.5, 0.8, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGamePrimaryInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _gameDetails.title.toUpperCase(),
                    style: const TextStyle(
                      color: primaryTextColor,
                      fontSize: 24,
                      fontFamily: 'General Sans Variable',
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      letterSpacing: 0.96,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(_gameDetails.genre, style: const TextStyle(color: secondaryTextColor, fontSize: 11, fontFamily: 'General Sans Variable', fontWeight: FontWeight.w600)),
                      _buildDotSeparator(),
                      Text(_gameDetails.developer, style: const TextStyle(color: secondaryTextColor, fontSize: 11, fontFamily: 'General Sans Variable', fontWeight: FontWeight.w600)),
                      _buildDotSeparator(),
                      Text(_gameDetails.releaseYear, style: const TextStyle(color: secondaryTextColor, fontSize: 11, fontFamily: 'General Sans Variable', fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      _gameDetails.overallRating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: primaryTextColor,
                        fontSize: 28,
                        fontFamily: 'General Sans Variable',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      "assets/images/games.png",
                      width: 28,
                      height: 28,
                      color: accentColor,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _gameDetails.totalVotes,
                  style: const TextStyle(
                    color: primaryTextColor,
                    fontSize: 10,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDotSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(
            color: secondaryTextColor, shape: BoxShape.circle),
      ),
    );
  }

  Widget _buildRatingsSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildRatingBar(
          label: 'Starnest Rating:',
          displayValue: _gameDetails.starnestRatingDisplay,
          progressValue: _gameDetails.starnestRatingValue,
        ),
        const SizedBox(height: 20),
        _buildRatingBar(
          label: 'Audience Rating:',
          displayValue: _gameDetails.audienceRatingDisplay,
          progressValue: _gameDetails.audienceRatingValue,
        ),
      ],
    );
  }

  Widget _buildRatingBar({
    required String label,
    required String displayValue,
    required double progressValue,
  }) {
    final double ratingOutOfFive = progressValue * 5.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: secondaryTextColor,
            fontSize: 11,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.only(left: 8, top: 4,bottom: 4, right: 0),
          decoration: BoxDecoration(
            color: ratingBarBackgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Text(
                displayValue,
                style: const TextStyle(
                  color: primaryTextColor,
                  fontSize: 16,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(5, (i) {
                    int fullStars = ratingOutOfFive.floor();
                    double fraction = ratingOutOfFive - fullStars;
                    Color filledStarColor = accentColor;
                    Color emptyStarColor = Colors.grey[700]!;

                    Widget star;
                    if (i < fullStars) {
                      star = Image.asset("assets/images/games.png", width: 16, height: 16, color: filledStarColor);
                    } else if (i == fullStars && fraction >= 0.25) {
                      star = Stack(
                        children: [
                          Image.asset("assets/images/games.png", width: 16, height: 16, color: emptyStarColor),
                          ClipRect(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              widthFactor: fraction,
                              child: Image.asset("assets/images/games.png", width: 16, height: 16, color: filledStarColor),
                            ),
                          ),
                        ],
                      );
                    } else {
                      star = Image.asset("assets/images/games.png", width: 16, height: 16, color: emptyStarColor);
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: star,
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSynopsisSection() {
    return Text(
      _gameDetails.synopsis,
      style: const TextStyle(
        color: primaryTextColor,
        fontSize: 12,
        fontFamily: 'General Sans Variable',
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
    );
  }

  Widget _buildTagChips() {
    return Wrap(
      spacing: 4.0,
      runSpacing: 4.0,
      children: _gameDetails.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.75, vertical: 4.0),
          decoration: ShapeDecoration(
            color: ratingBarBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          ),
          child: Text(
            tag,
            style: const TextStyle(
              color: secondaryTextColor,
              fontSize: 8,
              fontFamily: 'Product Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }).toList(),
    );
  }

  // CORRECTED: 'Rate this Product' section to match other screens
  Widget _buildRateThisProductSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rate this Game',
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'General Sans Variable',
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tell us what you think about this Game',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'General Sans Variable',
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: secondaryTextColor, thickness: 0.5), // FIXED: Added divider
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  final rating = index + 1;
                  Get.to(() => AddEditReviewScreen(
                    itemName: _gameDetails.title,
                    itemType: "Game",
                    accentColor: accentColor,
                    ratingAssetPath: "assets/images/games.png",
                    initialRating: rating.toDouble(),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 11.0),
                  child: Image.asset(
                    "assets/images/games.png",
                    width: 24,
                    height: 24,
                    color: index < _userGivenRating ? accentColor : unselectedStarColor,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsListHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverHeaderDelegate(
        child: Container(
          color: screenBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reviews and Ratings',
                style: TextStyle(color: primaryTextColor, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'General Sans Variable'),
              ),
              Text(
                '${_gameDetails.userReviews.length} ratings',
                style: const TextStyle(color: Color(0xFFCBCBCB), fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'General Sans Variable'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CORRECTED: Reviews list structure and padding
  Widget _buildReviewsList() {
    final reviews = _gameDetails.userReviews;
    if (reviews.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text("No reviews yet.", style: TextStyle(color: secondaryTextColor, fontSize: 14))),
        ),
      );
    }
    final itemCount = reviews.length > _initialReviewCount ? _initialReviewCount : reviews.length;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final isFirstItem = index == 0;
            if (isFirstItem) {
              return ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: _buildReviewItem(reviews[index]),
              );
            }
            return _buildReviewItem(reviews[index]);
          },
          childCount: itemCount,
        ),
      ),
    );
  }

  // CORRECTED: View More button to match style
  Widget _buildViewMoreButton() {
    return GestureDetector(
      onTap: () {
        final List<Comment> comments = _gameDetails.userReviews.map((review) {
          return Comment(
            author: review.userName,
            date: DateFormat('d MMM').format(review.date),
            rating: review.ratingGiven,
            title: review.reviewTitle,
            content: review.reviewText,
            likes: review.likes,
            replies: 0, // Placeholder
            authorAvatarUrl: review.avatarUrl ?? "",
          );
        }).toList();

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CommentsScreen(
            comments: comments,
            itemTitle: _gameDetails.title,
            iconAssetPath: "assets/images/games.png",
            iconColor: gameAccentColor,
          ),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: const BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
            ),
            border: Border(
              top: BorderSide(width: 1, color: Color(0xFF191919)),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'View More ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontFamily: 'General Sans Variable',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.white, size: 15)
            ],
          ),
        ),
      ),
    );
  }

  // CORRECTED: Review item to fix fonts, layout and like/dislike buttons
  Widget _buildReviewItem(GameReview review) {
    final formattedDate = DateFormat('d MMM').format(review.date);
    final bool isLiked = _reviewInteractionStatus[review.id] == true;
    final bool isDisliked = _reviewInteractionStatus[review.id] == false;

    // Simulation for display purposes
    final int displayLikes = review.likes + (isLiked ? 1 : 0);
    final int displayDislikes = review.dislikes + (isDisliked ? 1 : 0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: cardBgColor,
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: review.avatarUrl != null ? NetworkImage(review.avatarUrl!) : null,
                      backgroundColor: accentColor.withOpacity(0.3),
                      child: review.avatarUrl == null ? Text(review.userName.isNotEmpty ? review.userName[0].toUpperCase() : "U", style: const TextStyle(color: primaryTextColor)) : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.userName,
                          style: const TextStyle(color: primaryTextColor, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'General Sans Variable'),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(color: secondaryTextColor, fontSize: 8, fontWeight: FontWeight.w600, fontFamily: 'General Sans Variable'),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ratingBarBackgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        review.ratingGiven.toStringAsFixed(1),
                        style: const TextStyle(
                          color: primaryTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'General Sans Variable',
                        ),
                      ),
                      const SizedBox(width: 4),
                      ...List.generate(5, (index) {
                        final rating = review.ratingGiven;
                        Widget star;

                        if (index < rating.floor()) {
                          // Full star
                          star = Image.asset(
                            "assets/images/games.png",
                            width: 14,
                            height: 14,
                            color: accentColor,
                          );
                        } else if (index < rating) {
                          // Partial star
                          star = Stack(
                            children: [
                              Image.asset(
                                "assets/images/games.png",
                                width: 14,
                                height: 14,
                                color: unselectedStarColor,
                              ),
                              ClipRect(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: rating - index,
                                  child: Image.asset(
                                    "assets/images/games.png",
                                    width: 14,
                                    height: 14,
                                    color: accentColor,
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Empty star
                          star = Image.asset(
                            "assets/images/games.png",
                            width: 14,
                            height: 14,
                            color: unselectedStarColor,
                          );
                        }

                        return Padding(
                          padding: EdgeInsets.only(left: index == 0 ? 0 : 2.0),
                          child: star,
                        );
                      }),
                    ],
                  ),
                ),

              ],
            ),
          ),
          const SizedBox(height: 14),
          if (review.reviewTitle.isNotEmpty) ...[
            Text(
              review.reviewTitle,
              style: const TextStyle(color: primaryTextColor, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'General Sans Variable'),
            ),
            const SizedBox(height: 6),
          ],
          Text(
            review.reviewText,
            style: TextStyle(color: primaryTextColor.withOpacity(0.85), fontSize: 10, fontWeight: FontWeight.w500, fontFamily: 'General Sans Variable', height: 1.4), // FIXED: Font size and weight
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLikeDislikeButton(
                filledIconPath: "assets/images/thum_up.png", // FIXED: Correct icon paths
                outlinedIconPath: "assets/images/thum_up.png",
                count: displayLikes,
                isToggled: isLiked,
                onPressed: () => _handleReviewInteraction(review.id, true),
              ),
              const SizedBox(width: 16),
              _buildLikeDislikeButton(
                filledIconPath: "assets/images/thum_down.png",
                outlinedIconPath: "assets/images/thum_down.png",
                count: displayDislikes,
                isToggled: isDisliked,
                onPressed: () => _handleReviewInteraction(review.id, false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLikeDislikeButton({
    required String filledIconPath,
    required String outlinedIconPath,
    required int count,
    required bool isToggled,
    required VoidCallback onPressed,
  }) {
    final Color iconAndTextColor = isToggled ? accentColor : secondaryTextColor;
    final String iconPath = isToggled ? filledIconPath : outlinedIconPath;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              color: iconAndTextColor,
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 6),
            Text(
              count.toString(),
              style: TextStyle(
                color: iconAndTextColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                fontFamily: 'General Sans Variable',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  _SliverHeaderDelegate({
    required this.child,
    this.minHeight = 50.0,
    this.maxHeight = 50.0,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
