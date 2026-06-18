import 'dart:async';
import '../tracking_client.dart';
import '../models/track_event.dart';

mixin AppEvents {
  void appOpen({String? userId}) {
    unawaited(TrackingClient.instance.postEvent(
      TrackEvent(
        eventType: 'app_open',
        targetType: 'app',
        targetId: 'mobile_app',
        userId: userId ?? TrackingClient.instance.userId,
      ),
    ));
  }

  void appClose({int? sessionDurationSec, String? userId}) {
    unawaited(TrackingClient.instance.postEvent(
      TrackEvent(
        eventType: 'app_close',
        targetType: 'app',
        targetId: 'mobile_app',
        userId: userId ?? TrackingClient.instance.userId,
        metadata: sessionDurationSec != null ? {'session_duration_sec': sessionDurationSec} : null,
      ),
    ));
  }
}
