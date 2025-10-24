// models/movie_review_details_model.dart

class MovieReviewDetails {
  final String id;
  final String title;
  final String imageUrl; // For the main backdrop/poster
  final String duration;
  final String certification;
  final String language;
  final double overallRating;
  final String totalVotes;
  final double starnestRatingValue; // 0.0 to 1.0 for progress bar
  final String starnestRatingDisplay; // e.g., "4.5"
  final double audienceRatingValue; // 0.0 to 1.0
  final String audienceRatingDisplay; // e.g., "4.3"
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
    required this.starnestRatingValue,
    required this.starnestRatingDisplay,
    required this.audienceRatingValue,
    required this.audienceRatingDisplay,
    required this.synopsis,
    required this.genres,
    required this.photoUrls,
    required this.userReviews,
  });
}

class UserReview {
  final String id;
  final String userName;
  final String avatarUrl; // Optional
  final DateTime date;
  final double ratingGiven; // e.g., 4.3 out of 5
  final String reviewTitle;
  final String reviewText;
  final int likes;
  final int dislikes;

  UserReview({
    required this.id,
    required this.userName,
    this.avatarUrl = "",
    required this.date,
    required this.ratingGiven,
    required this.reviewTitle,
    required this.reviewText,
    required this.likes,
    required this.dislikes,
  });
}

