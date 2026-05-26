import 'dart:async';
import '../tracking_client.dart';
import '../event_logger.dart';

mixin SessionEvents {
  void sessionStart({required String token, required String userId, String? sessionId}) {
    TrackingClient.instance.setAuth(token, userId);
    EventLogger.logEvent("session_start", {
      "session_id": sessionId,
      "target_type": "session",
      "target_id": sessionId ?? userId,
    });
  }

  void sessionEnd({required String userId, String? sessionId}) {
    unawaited(TrackingClient.instance.post('/api/users/logout', {
      "user_id": userId,
      "session_id": sessionId,
    }));
    TrackingClient.instance.clearAuth();
    EventLogger.logEvent("session_end", {
      "session_id": sessionId,
      "target_type": "session",
      "target_id": sessionId ?? userId,
    });
  }
}
