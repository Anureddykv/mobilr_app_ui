import 'dart:async';
import '../tracking_client.dart';
import '../models/track_event.dart';

mixin TagEvents {
  void trackTagFollow({
    required String tagId,
    String? userId,
  }) {
    unawaited(TrackingClient.instance.post('/api/tags/$tagId/follow', {
      "user_id": userId ?? TrackingClient.instance.userId,
    }));
  }

  void trackTagUnfollow({
    required String tagId,
    String? userId,
  }) {
    unawaited(TrackingClient.instance.delete('/api/tags/$tagId/follow', {
      "user_id": userId ?? TrackingClient.instance.userId,
    }));
  }

  void trackTagImpression({
    required String tagId,
    String? userId,
  }) {
    unawaited(TrackingClient.instance.postEvent(
      TrackEvent(
        eventType: 'impression',
        targetType: 'tag',
        targetId: tagId,
        userId: userId ?? TrackingClient.instance.userId,
      ),
    ));
  }

  void trackTagClick({
    required String tagId,
    String? userId,
  }) {
    unawaited(TrackingClient.instance.postEvent(
      TrackEvent(
        eventType: 'click',
        targetType: 'tag',
        targetId: tagId,
        userId: userId ?? TrackingClient.instance.userId,
      ),
    ));
  }

  void trackTagView({
    required String tagId,
    String? userId,
  }) {
    unawaited(TrackingClient.instance.postEvent(
      TrackEvent(
        eventType: 'view',
        targetType: 'tag',
        targetId: tagId,
        userId: userId ?? TrackingClient.instance.userId,
      ),
    ));
  }
}
