import 'dart:async';
import 'dart:developer';
import '../tracking_client.dart';
import '../event_logger.dart';
import '../../service/user_session.dart';

mixin SessionEvents {
  void sessionStart({
    required String token,
    required String userId,
    String? sessionId,
    String? firstName,
    String? lastName,
    String? email,
    String? avatarUrl,
  }) {
    log('''
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔐 SESSION START
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
userId    : "$userId"
sessionId : "$sessionId"
token     : "${token.isEmpty ? "(empty)" : token.substring(0, token.length.clamp(0, 20))}..."
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
''', name: 'starnest.tracker');

    // Persist to global UserSession so any widget can access it
    if (sessionId != null && sessionId.isNotEmpty) {
      UserSession.instance.save(
        userId: userId,
        sessionId: sessionId,
        token: token,
        firstName: firstName,
        lastName: lastName,
        email: email,
        avatarUrl: avatarUrl,
      );
    }
    TrackingClient.instance.setAuth(token, userId, sessionId: sessionId);

    log(
      '✅ TrackingClient after setAuth → userId="${TrackingClient.instance.userId}" sessionId="${TrackingClient.instance.sessionId}"',
      name: 'starnest.tracker',
    );

    EventLogger.logEvent("session_start", {
      "session_id": sessionId,
      "target_type": "session",
      "target_id": sessionId ?? userId,
    });
  }

  void sessionEnd({required String userId, String? sessionId}) {
    final sid = sessionId ?? UserSession.instance.sessionId;
    unawaited(
      TrackingClient.instance.post('/api/users/logout', {
        "user_id": userId,
        "session_id": sid,
      }),
    );
    UserSession.instance.clear();
    TrackingClient.instance.clearAuth();
    EventLogger.logEvent("session_end", {
      "session_id": sid,
      "target_type": "session",
      "target_id": sid ?? userId,
    });
  }
}
