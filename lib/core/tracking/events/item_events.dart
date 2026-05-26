import 'dart:async';
import '../tracking_client.dart';

mixin ItemEvents {
  /// Impression must only fire after item is visible for >1 second. 
  /// The caller is responsible for the timer delay — this method just sends the event.
  void trackImpression({
    required String module,
    required String itemId,
    String? userId,
    String? section,
    int? position,
  }) {
    unawaited(TrackingClient.instance.post('/api/$module/$itemId/event', {
      "event_type": "impression",
      "user_id": userId ?? TrackingClient.instance.userId,
      "context": (section != null || position != null) 
          ? {"section": section, "position": position} 
          : null,
    }));
  }

  void trackClick({
    required String module,
    required String itemId,
    String? userId,
    String? sessionId,
    String? section,
    int? position,
  }) {
    unawaited(TrackingClient.instance.post('/api/$module/$itemId/click', {
      "user_id": userId ?? TrackingClient.instance.userId,
      "session_id": sessionId,
      "context": (section != null || position != null) 
          ? {"section": section, "position": position} 
          : null,
    }));
  }

  void trackView({
    required String module,
    required String itemId,
    String? userId,
  }) {
    unawaited(TrackingClient.instance.post('/api/$module/$itemId/event', {
      "event_type": "view",
      "user_id": userId ?? TrackingClient.instance.userId,
    }));
  }

  void trackBookmarkAdd({
    required String module,
    required String itemId,
    String? userId,
  }) {
    unawaited(TrackingClient.instance.post('/api/$module/$itemId/bookmark', {
      "user_id": userId ?? TrackingClient.instance.userId,
    }));
  }

  void trackBookmarkRemove({
    required String module,
    required String itemId,
    String? userId,
  }) {
    unawaited(TrackingClient.instance.delete('/api/$module/$itemId/bookmark', {
      "user_id": userId ?? TrackingClient.instance.userId,
    }));
  }

  void trackNotifyEnable({
    required String module,
    required String itemId,
    String? userId,
  }) {
    unawaited(TrackingClient.instance.post('/api/$module/$itemId/notify', {
      "user_id": userId ?? TrackingClient.instance.userId,
    }));
  }

  void trackNotifyDisable({
    required String module,
    required String itemId,
    String? userId,
  }) {
    unawaited(TrackingClient.instance.delete('/api/$module/$itemId/notify', {
      "user_id": userId ?? TrackingClient.instance.userId,
    }));
  }

  void trackShare({
    required String module,
    required String itemId,
    required String channel,
    String? userId,
  }) {
    assert(channel.isNotEmpty, 'channel is required for trackShare');
    unawaited(TrackingClient.instance.post('/api/$module/$itemId/event', {
      "event_type": "share",
      "user_id": userId ?? TrackingClient.instance.userId,
      "metadata": {"channel": channel}
    }));
  }

  void trackReport({
    required String module,
    required String itemId,
    required String reason,
    String? userId,
  }) {
    assert(reason.isNotEmpty, 'reason is required for trackReport');
    unawaited(TrackingClient.instance.post('/api/$module/$itemId/event', {
      "event_type": "report",
      "user_id": userId ?? TrackingClient.instance.userId,
      "metadata": {"reason": reason}
    }));
  }
}
