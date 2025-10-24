import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For Get.snackbar (optional)
import 'package:intl/intl.dart';
import 'package:mobilr_app_ui/chat/comments_screen.dart';
import 'package:mobilr_app_ui/home/controllers/home_controller.dart';
import 'package:mobilr_app_ui/review/add_edit_review_screen.dart';

// --- Data Models (Ideally in separate files) ---
class MovieReviewDetails {
  final String id;
  final String title;
  final String imageUrl;
  final String duration;
  final String certification;
  final String language;
  final double overallRating;
  final String totalVotes;
  final String starnestRatingDisplay;
  final double starnestRatingValue; // e.g., 4.5 out of 5.0 -> 0.9
  final String audienceRatingDisplay;
  final double audienceRatingValue; // e.g., 4.3 out of 5.0 -> 0.86
  final String synopsis;
  final List<String> genres;
  final List<String> photoUrls; // For the gallery
  final List<UserReview> userReviews;

  MovieReviewDetails({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.certification,
    required this.language,
    required this.overallRating,
    required this.totalVotes,
    required this.starnestRatingDisplay,
    required this.starnestRatingValue,
    required this.audienceRatingDisplay,
    required this.audienceRatingValue,
    required this.synopsis,
    required this.genres,
    required this.photoUrls,
    required this.userReviews,
  });
}

class UserReview {
  final String id;
  final String userName;
  final DateTime date;
  final double ratingGiven;
  final String reviewTitle;
  final String reviewText;
  final int likes;
  final int dislikes;
  final String? avatarUrl; // Optional

  UserReview({
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
const Color accentColor = Color(0xFF54B6E0); // Main accent for stars, buttons
const Color ratingBarBackgroundColor = Color(0xFF1E1E1E);
const Color unselectedStarColor = Color(0xFF4B4B4B);

class MainReviewScreenMovies extends StatefulWidget {
  final String movieId; // To know which movie's reviews to show

  const MainReviewScreenMovies({super.key, required this.movieId});

  @override
  State<MainReviewScreenMovies> createState() => _MainReviewScreenMoviesState();
}

class _MainReviewScreenMoviesState extends State<MainReviewScreenMovies> {
  late MovieReviewDetails _movieDetails;
  bool _isLoading = true;
  int _userGivenRating = 0; // For the "Rate this Movie" stars

  final TextEditingController _reviewController = TextEditingController();
  bool _showAllReviews = false;
  final int _initialReviewCount = 2;

  // NEW: Map to track user's like/dislike status for each review
  // Key: review.id, Value: true for like, false for dislike, null for no interaction
  final Map<String, bool?> _reviewInteractionStatus = {};


  @override
  void initState() {
    super.initState();
    _fetchMovieReviewDetails();
  }

  Future<void> _fetchMovieReviewDetails() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      _movieDetails = MovieReviewDetails(
        id: widget.movieId,
        title: 'SALAAR',
        imageUrl: "https://image.tmdb.org/t/p/w500/vJL6OaZp2225T1PLa2L4A2I2V5.jpg",
        duration: "2h 35m",
        certification: "U/A",
        language: "Telugu",
        overallRating: 4.5,
        totalVotes: "4.6k Votes",
        starnestRatingDisplay: "4.5",
        starnestRatingValue: 4.5 / 5.0,
        audienceRatingDisplay: "4.3",
        audienceRatingValue: 4.3 / 5.0,
        synopsis: "In Salaar, a fierce warrior rises against a tyrannical regime to protect his friend and reclaim justice through violence. This is a longer text to test wrapping and layout in the synopsis section.",
        genres: ["Action", "Thriller", "Suspense", "Adventure", "Drama", "Epic"],
        photoUrls: [
          "https://image.tmdb.org/t/p/w500/18aKk5hB03vETQ2sN2iE9ESd92w.jpg",
          "https://image.tmdb.org/t/p/w500/kSVKwZ21mML3M1gK3y2S0iB0k0j.jpg",
          "https://image.tmdb.org/t/p/w500/zN3gPSB2n4TjL2yICf2g2a1zTNA.jpg",
        ],
        userReviews: [
          UserReview(id: 'r1', userName: 'Rohit Sharma', date: DateTime.now().subtract(const Duration(days: 1)), ratingGiven: 4.3, reviewTitle: 'Amazing Visuals & Action!', reviewText: 'Lorem ipsum sagittis blandit metus nec ultrices tempus neque sit aliquam amet nisi aenean non tristique id ac in lectus laoreet interdum aliquam a donec interdum cursus condimentum massa sed.', likes: 115, dislikes: 4, avatarUrl: "https://placehold.co/40x40/FFC0CB/000?text=RS"),
          UserReview(id: 'r2', userName: 'Priya Kumari', date: DateTime.now().subtract(const Duration(days: 2)), ratingGiven: 5.0, reviewTitle: 'A Must Watch Blockbuster!', reviewText: 'A masterpiece of storytelling and action. The performances were outstanding and the plot kept me on the edge of my seat throughout the entire film. Highly recommended for all movie lovers seeking an adrenaline rush!', likes: 250, dislikes: 1, avatarUrl: "https://placehold.co/40x40/ADD8E6/000?text=PK"),
          UserReview(id: 'r3', userName: 'Anonymous User', date: DateTime.now().subtract(const Duration(days: 5)), ratingGiven: 3.5, reviewTitle: 'Decent, but a bit long', reviewText: 'The movie had its moments, but it felt dragged out in certain parts. The visuals were good, though. Worth a one-time watch perhaps.', likes: 45, dislikes: 12),
        ],
      );
      _isLoading = false;
    });
  }

  // NEW: Method to handle like/dislike logic
  void _handleReviewInteraction(String reviewId, bool isLikeButton) {
    setState(() {
      // Get the current status for the review
      final currentStatus = _reviewInteractionStatus[reviewId];

      if (isLikeButton) {
        // If the user tapped 'like'
        if (currentStatus == true) {
          // If it was already liked, unlike it
          _reviewInteractionStatus[reviewId] = null;
        } else {
          // Otherwise, like it (this also overrides a dislike)
          _reviewInteractionStatus[reviewId] = true;
        }
      } else {
        // If the user tapped 'dislike'
        if (currentStatus == false) {
          // If it was already disliked, undislike it
          _reviewInteractionStatus[reviewId] = null;
        } else {
          // Otherwise, dislike it (this also overrides a like)
          _reviewInteractionStatus[reviewId] = false;
        }
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
                    child: _buildMoviePrimaryInfo(),
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
                              _buildGenreTags(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildRateThisMovieSection(),
                  ),
                  const SizedBox(height: 24),
                  _buildPhotoGallerySection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildReviewsListHeader(),
          _buildReviewsList(),
          if (_movieDetails.userReviews.length > _initialReviewCount && !_showAllReviews)
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
              _movieDetails.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.grey[800], child: const Icon(Icons.error_outline, color: Colors.white24, size: 48)),
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

  Widget _buildMoviePrimaryInfo() {
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
                    _movieDetails.title.toUpperCase(),
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
                      Text(_movieDetails.duration, style: const TextStyle(color: secondaryTextColor, fontSize: 11, fontFamily: 'General Sans Variable', fontWeight: FontWeight.w600)),
                      _buildDotSeparator(),
                      Text(_movieDetails.certification, style: const TextStyle(color: secondaryTextColor, fontSize: 11, fontFamily: 'General Sans Variable', fontWeight: FontWeight.w600)),
                      _buildDotSeparator(),
                      Text(_movieDetails.language, style: const TextStyle(color: secondaryTextColor, fontSize: 11, fontFamily: 'General Sans Variable', fontWeight: FontWeight.w600)),
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
                      _movieDetails.overallRating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: primaryTextColor,
                        fontSize: 20,
                        fontFamily: 'General Sans Variable',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      "assets/images/sd.png",
                      width: 20,
                      height: 20,
                      color: accentColor,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _movieDetails.totalVotes,
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

  Widget _buildViewMoreButton() {
    return GestureDetector(
      onTap: () {
        final List<Comment> comments = _movieDetails.userReviews.map((review) {
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
            itemTitle: _movieDetails.title,
            iconAssetPath: "assets/images/sd.png",
            iconColor: movieAccentColor,
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

  Widget _buildDotSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(color: secondaryTextColor, shape: BoxShape.circle),
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
          displayValue: _movieDetails.starnestRatingDisplay,
          progressValue: _movieDetails.starnestRatingValue,
        ),
        const SizedBox(height: 20),
        _buildRatingBar(
          label: 'Audience Rating:',
          displayValue: _movieDetails.audienceRatingDisplay,
          progressValue: _movieDetails.audienceRatingValue,
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                      star = Image.asset("assets/images/sd.png", width: 14, height: 14, color: filledStarColor);
                    } else if (i == fullStars && fraction >= 0.25) {
                      star = Stack(
                        children: [
                          Image.asset("assets/images/sd.png", width: 14, height: 14, color: emptyStarColor),
                          ClipRect(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              widthFactor: fraction,
                              child: Image.asset("assets/images/sd.png", width: 14, height: 14, color: filledStarColor),
                            ),
                          ),
                        ],
                      );
                    } else {
                      star = Image.asset("assets/images/sd.png", width: 14, height: 14, color: emptyStarColor);
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
      _movieDetails.synopsis,
      style: const TextStyle(
        color: primaryTextColor,
        fontSize: 12,
        fontFamily: 'General Sans Variable',
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
    );
  }

  Widget _buildGenreTags() {
    return Wrap(
      spacing: 4.0,
      runSpacing: 4.0,
      children: _movieDetails.genres.map((genre) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.75, vertical: 4.0),
          decoration: ShapeDecoration(
            color: ratingBarBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          ),
          child: Text(
            genre,
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

  Widget _buildRateThisMovieSection() {
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
            'Rate this Movie',
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'General Sans Variable',
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tell us what you think about this Film',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'General Sans Variable',
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: secondaryTextColor, thickness: 0.5),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  final rating = index + 1;
                  Get.to(() => AddEditReviewScreen(
                    itemName: _movieDetails.title,
                    itemType: "Movie",
                    accentColor: accentColor, // Use the movie's accent color
                    ratingAssetPath: "assets/images/sd.png",
                    initialRating: rating.toDouble(),
                  ));
                },

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Image.asset(
                    "assets/images/sd.png",
                    width: 32,
                    height: 32,
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

  Widget _buildPhotoGallerySection() {
    if (_movieDetails.photoUrls.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: buildSectionTitle("Gallery"),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _movieDetails.photoUrls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    _movieDetails.photoUrls[index],
                    width: 150,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(width: 150, height: 100, color: Colors.grey[700], child: const Icon(Icons.broken_image, color: Colors.white24)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
                '${_movieDetails.userReviews.length} ratings',
                style: const TextStyle(color: Color(0xFFCBCBCB), fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'General Sans Variable'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsList() {
    final reviews = _movieDetails.userReviews;
    if (reviews.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text("No reviews yet.", style: TextStyle(color: secondaryTextColor, fontSize: 14))),
        ),
      );
    }
    final itemCount = _showAllReviews ? reviews.length : (reviews.length > _initialReviewCount ? _initialReviewCount : reviews.length);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Apply horizontal padding to the entire list
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final isFirstItem = index == 0;

            // Apply a radius only to the top corners of the first item in the list.
            if (isFirstItem) {
              return ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: _buildReviewItem(reviews[index]),
              );
            }

            // Return the regular item for all other items.
            return _buildReviewItem(reviews[index]);
          },
          childCount: itemCount,
        ),
      ),
    );
  }

  // MODIFIED AND CORRECTED WIDGET
  Widget _buildReviewItem(UserReview review) {
    final formattedDate = DateFormat('d MMM').format(review.date);

    // Get the current interaction status for this specific review
    final bool isLiked = _reviewInteractionStatus[review.id] == true;
    final bool isDisliked = _reviewInteractionStatus[review.id] == false;

    // Adjust like/dislike counts based on interaction.
    // This is a simulation; in a real app, this would be handled by a backend.
    final int displayLikes = review.likes + (isLiked ? 1 : 0) - (isDisliked && _reviewInteractionStatus.containsKey(review.id) ? 1 : 0);
    final int displayDislikes = review.dislikes + (isDisliked ? 1 : 0) - (isLiked && _reviewInteractionStatus.containsKey(review.id) ? 1 : 0);


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
                            "assets/images/sd.png",
                            width: 14,
                            height: 14,
                            color: accentColor,
                          );
                        } else if (index < rating) {
                          // Partial star
                          star = Stack(
                            children: [
                              Image.asset(
                                "assets/images/sd.png",
                                width: 14,
                                height: 14,
                                color: unselectedStarColor,
                              ),
                              ClipRect(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: rating - index,
                                  child: Image.asset(
                                    "assets/images/sd.png",
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
                            "assets/images/sd.png",
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
                )
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
            style: TextStyle(color: primaryTextColor.withOpacity(0.85), fontSize: 10, fontWeight: FontWeight.w500, fontFamily: 'General Sans Variable', height: 1.4),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLikeDislikeButton(
                filledIconPath: "assets/images/thum_up.png",
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

  // MODIFIED AND CORRECTED WIDGET
  Widget _buildLikeDislikeButton({
    required String filledIconPath,
    required String outlinedIconPath,
    required int count,
    required bool isToggled,
    required VoidCallback onPressed,
  }) {
    // Determine the color and icon path based on the toggled state
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
              width: 16,
              height: 16,
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

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: primaryTextColor, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'General Sans Variable'),
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
