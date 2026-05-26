import 'dart:async';
import '../tracking_client.dart';
import '../models/track_event.dart';

mixin SearchEvents {
  void trackSearch({
    required String query,
    String? userId,
  }) {
    assert(query.isNotEmpty, 'query must not be empty');
    unawaited(TrackingClient.instance.postEvent(
      TrackEvent(
        eventType: 'search',
        targetType: 'search_query',
        targetId: 'srch_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId ?? TrackingClient.instance.userId,
        metadata: {'query': query},
      ),
    ));
  }
}
