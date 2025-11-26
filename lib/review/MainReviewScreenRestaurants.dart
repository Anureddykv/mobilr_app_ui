import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For Get.snackbar (optional)
import 'package:intl/intl.dart';
import 'package:mobilr_app_ui/chat/comments_screen.dart';
import 'package:mobilr_app_ui/review/add_edit_review_screen.dart'; // For date formatting

// --- Data Models (Refactored for Restaurants) ---
class ItemReviewDetails { // <-- RENAMED from MovieReviewDetails
  final String id;
  final String title;
  final String imageUrl;
  final String avgCost; // <-- CHANGED from duration
  final String certification; // e.g., 'Veg', 'Non-Veg', 'FSSAI Certified'
  final String location; // <-- CHANGED from language
  final double overallRating;
  final String totalVotes;
  final String starnestRatingDisplay;
  final double starnestRatingValue;
  final String audienceRatingDisplay;
  final double audienceRatingValue;
  final String description; // <-- CHANGED from synopsis
  final List<String> cuisines; // <-- CHANGED from genres
  final List<String> photoUrls;
  final List<UserReview> userReviews;

  ItemReviewDetails({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.avgCost,
    required this.certification,
    required this.location,
    required this.overallRating,
    required this.totalVotes,
    required this.starnestRatingDisplay,
    required this.starnestRatingValue,
    required this.audienceRatingDisplay,
    required this.audienceRatingValue,
    required this.description,
    required this.cuisines,
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
  final String? avatarUrl;

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
const Color accentColor = Color(0xFFF9C74F); // <-- UPDATED ACCENT COLOR
const Color ratingBarBackgroundColor = Color(0xFF1E1E1E);
const Color unselectedStarColor = Color(0xFF4B4B4B);


// <-- RENAMED Widget
class RestaurantReviewScreen extends StatefulWidget {
  final String itemId; // <-- CHANGED from movieId

  const RestaurantReviewScreen({super.key, required this.itemId});

  @override
  State<RestaurantReviewScreen> createState() => _RestaurantReviewScreenState();
}

class _RestaurantReviewScreenState extends State<RestaurantReviewScreen> {
  late ItemReviewDetails _itemDetails; // <-- CHANGED from _movieDetails
  bool _isLoading = true;
  int _userGivenRating = 0; // For the "Rate this Item" stars

  final TextEditingController _reviewController = TextEditingController();
  final int _initialReviewCount = 2;

  // NEW: Map to track user's like/dislike status for each review
  // Key: review.id, Value: true for like, false for dislike, null for no interaction
  final Map<String, bool?> _reviewInteractionStatus = {};


  @override
  void initState() {
    super.initState();
    _fetchItemReviewDetails();
  }

  // <-- RENAMED Method
  Future<void> _fetchItemReviewDetails() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      // <-- UPDATED with restaurant data
      _itemDetails = ItemReviewDetails(
        id: widget.itemId,
        title: 'Bawarchi Restaurant',
        imageUrl: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=2070&auto=format&fit=crop",
        avgCost: "\$20 for two",
        certification: "FSSAI",
        location: "Hyderabad",
        overallRating: 4.2,
        totalVotes: "1.2k Votes",
        starnestRatingDisplay: "4.4",
        starnestRatingValue: 4.4 / 5.0,
        audienceRatingDisplay: "4.1",
        audienceRatingValue: 4.1 / 5.0,
        description: "An authentic place for Hyderabadi Biryani and traditional Indian cuisine. Known for its rich flavors and aromatic spices that attract food lovers from all over the city.",
        cuisines: ["Indian", "Hyderabadi", "Chinese", "Mughlai", "North Indian"],
        photoUrls: [
          "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=1974&auto=format&fit=crop",
          "https://images.unsplash.com/photo-1552566626-52f8b828add9?q=80&w=2070&auto=format&fit=crop",
          "https://images.unsplash.com/photo-1590846406792-0adc7f938f1d?q=80&w=1885&auto=format&fit=crop",
        ],
        userReviews: [
          UserReview(id: 'r1', userName: 'Ankit Sharma', date: DateTime.now().subtract(const Duration(days: 1)), ratingGiven: 4.5, reviewTitle: 'Best Biryani in Town!', reviewText: 'The biryani was absolutely delicious. The ambiance is great for family dinners. A must-visit place for anyone craving authentic flavors. Service was quick and professional.', likes: 98, dislikes: 2, avatarUrl: "https://placehold.co/40x40/FFC0CB/000?text=AS"),
          UserReview(id: 'r2', userName: 'Sneha Reddy', date: DateTime.now().subtract(const Duration(days: 3)), ratingGiven: 5.0, reviewTitle: 'Fantastic Experience!', reviewText: 'Loved everything about this place. The food, the service, and the atmosphere were all top-notch. Will be coming back for sure! Highly recommended.', likes: 150, dislikes: 0, avatarUrl: "https://placehold.co/40x40/ADD8E6/000?text=SR"),
          UserReview(id: 'r3', userName: 'Priya Verma', date: DateTime.now().subtract(const Duration(days: 5)), ratingGiven: 3.8, reviewTitle: 'Good, but could be better.', reviewText: 'The main course was great, especially the chicken tikka. However, the starters were a bit cold. The service was a little slow during peak hours.', likes: 45, dislikes: 8),
          UserReview(id: 'r4', userName: 'Rajesh Kumar', date: DateTime.now().subtract(const Duration(days: 10)), ratingGiven: 4.0, reviewTitle: 'A Solid Choice', reviewText: 'Reliable place for a good meal. Not extraordinary, but consistently good. The environment is clean and welcoming.', likes: 72, dislikes: 5, avatarUrl: "https://placehold.co/40x40/90EE90/000?text=RK"),
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
                    child: _buildItemPrimaryInfo(),
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
                              _buildDescriptionSection(),
                              const SizedBox(height: 16),
                              _buildCuisineTags(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildRateThisItemSection(),
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
          if (_itemDetails.userReviews.length > _initialReviewCount)
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
              _itemDetails.imageUrl, // <-- Use refactored model
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

  // <-- RENAMED Method
  Widget _buildItemPrimaryInfo() {
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
                    _itemDetails.title.toUpperCase(), // <-- Use refactored model
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
                      // <-- UPDATED info
                      Text(_itemDetails.avgCost, style: const TextStyle(color: secondaryTextColor, fontSize: 11, fontFamily: 'General Sans Variable', fontWeight: FontWeight.w600)),
                      _buildDotSeparator(),
                      Text(_itemDetails.certification, style: const TextStyle(color: secondaryTextColor, fontSize: 11, fontFamily: 'General Sans Variable', fontWeight: FontWeight.w600)),
                      _buildDotSeparator(),
                      Text(_itemDetails.location, style: const TextStyle(color: secondaryTextColor, fontSize: 11, fontFamily: 'General Sans Variable', fontWeight: FontWeight.w600)),
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
                      _itemDetails.overallRating.toStringAsFixed(1), // <-- Use refactored model
                      style: const TextStyle(
                        color: primaryTextColor,
                        fontSize: 28,
                        fontFamily: 'General Sans Variable',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      "assets/images/restaurants.png", // CORRECTED PATH
                      width: 28,
                      height: 28,
                      color: accentColor,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _itemDetails.totalVotes, // <-- Use refactored model
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
          displayValue: _itemDetails.starnestRatingDisplay,
          progressValue: _itemDetails.starnestRatingValue,
        ),
        const SizedBox(height: 20),
        _buildRatingBar(
          label: 'Audience Rating:',
          displayValue: _itemDetails.audienceRatingDisplay,
          progressValue: _itemDetails.audienceRatingValue,
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
          padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4, right: 0),
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
                      star = Image.asset("assets/images/restaurants.png", width: 16, height: 16, color: filledStarColor);
                    } else if (i == fullStars && fraction >= 0.25) {
                      star = Stack(
                        children: [
                          Image.asset("assets/images/restaurants.png", width: 16, height: 16, color: emptyStarColor),
                          ClipRect(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              widthFactor: fraction,
                              child: Image.asset("assets/images/restaurants.png", width: 16, height: 16, color: filledStarColor),
                            ),
                          ),
                        ],
                      );
                    } else {
                      star = Image.asset("assets/images/restaurants.png", width: 16, height: 16, color: emptyStarColor);
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

  Widget _buildDescriptionSection() {
    return Text(
      _itemDetails.description,
      style: const TextStyle(
        color: primaryTextColor,
        fontSize: 12,
        fontFamily: 'General Sans Variable',
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
    );
  }

  Widget _buildCuisineTags() {
    return Wrap(
      spacing: 4.0,
      runSpacing: 4.0,
      children: _itemDetails.cuisines.map((cuisine) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.75, vertical: 4.0),
          decoration: ShapeDecoration(
            color: ratingBarBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          ),
          child: Text(
            cuisine,
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

  // CORRECTED WIDGET
  Widget _buildRateThisItemSection() {
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
            'Rate this Restaurant',
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'General Sans Variable',
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tell us what you think about this Restaurant',
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
                    itemName: _itemDetails.title,
                    itemType: "Restaurant",
                    accentColor: accentColor,
                    ratingAssetPath: "assets/images/restaurants.png",
                    initialRating: rating.toDouble(),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 11.0),
                  child: Image.asset(
                    "assets/images/restaurants.png",
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

  Widget _buildPhotoGallerySection() {
    if (_itemDetails.photoUrls.isEmpty) return const SizedBox.shrink();

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
            itemCount: _itemDetails.photoUrls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    _itemDetails.photoUrls[index],
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
                '${_itemDetails.userReviews.length} ratings',
                style: const TextStyle(color: Color(0xFFCBCBCB), fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'General Sans Variable'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CORRECTED WIDGET
  Widget _buildReviewsList() {
    final reviews = _itemDetails.userReviews;
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

  // CORRECTED WIDGET
  Widget _buildViewMoreButton() {
    return GestureDetector(
      onTap: () {
        final List<Comment> comments = _itemDetails.userReviews.map((review) {
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
            itemTitle: _itemDetails.title,
            iconAssetPath: "assets/images/restaurants.png",
            iconColor: accentColor,
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

  // CORRECTED WIDGET
  Widget _buildReviewItem(UserReview review) {
    final formattedDate = DateFormat('d MMM').format(review.date);
    final bool isLiked = _reviewInteractionStatus[review.id] == true;
    final bool isDisliked = _reviewInteractionStatus[review.id] == false;

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
                            "assets/images/restaurants.png",
                            width: 14,
                            height: 14,
                            color: accentColor,
                          );
                        } else if (index < rating) {
                          // Partial star
                          star = Stack(
                            children: [
                              Image.asset(
                                "assets/images/restaurants.png",
                                width: 14,
                                height: 14,
                                color: unselectedStarColor,
                              ),
                              ClipRect(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: rating - index,
                                  child: Image.asset(
                                    "assets/images/restaurants.png",
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
                            "assets/images/restaurants.png",
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

  // CORRECTED WIDGET
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
