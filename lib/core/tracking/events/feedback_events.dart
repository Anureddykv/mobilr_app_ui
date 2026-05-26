import 'dart:async';
import '../tracking_client.dart';

mixin FeedbackEvents {
  void trackRating({
    required String itemId,
    required int rating,
    String? userId,
  }) {
    assert(rating >= 1 && rating <= 10, 'rating must be between 1 and 10');
    unawaited(TrackingClient.instance.post('/api/reviews', {
      "itemId": itemId,
      "userId": userId ?? TrackingClient.instance.userId,
      "rating": rating,
    }));
  }

  void trackReview({
    required String itemId,
    required String comment,
    String? userId,
  }) {
    unawaited(TrackingClient.instance.post('/api/reviews', {
      "itemId": itemId,
      "userId": userId ?? TrackingClient.instance.userId,
      "comment": comment,
    }));
  }

  void trackRatingReview({
    required String itemId,
    required int rating,
    required String comment,
    String? userId,
  }) {
    assert(rating >= 1 && rating <= 10, 'rating must be between 1 and 10');
    unawaited(TrackingClient.instance.post('/api/reviews', {
      "itemId": itemId,
      "userId": userId ?? TrackingClient.instance.userId,
      "rating": rating,
      "comment": comment,
    }));
  }
}
