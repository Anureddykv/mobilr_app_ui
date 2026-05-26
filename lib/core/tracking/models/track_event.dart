class TrackEvent {
  final String eventType;
  final String targetType; // "item" | "app" | "session" | "search_query" | "tag" | "comment"
  final String targetId;
  final String? userId;
  final String? sessionId;
  final Map<String, dynamic>? context; // { "section": "trending", "position": 1 }
  final dynamic value; // numeric value (e.g., rating 1–10)
  final Map<String, dynamic>? metadata; // arbitrary extra fields

  TrackEvent({
    required this.eventType,
    required this.targetType,
    required this.targetId,
    this.userId,
    this.sessionId,
    this.context,
    this.value,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'event_type': eventType,
      'target_type': targetType,
      'target_id': targetId,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };

    if (userId != null) data['user_id'] = userId;
    if (sessionId != null) data['session_id'] = sessionId;
    if (context != null) data['context'] = context;
    if (value != null) data['value'] = value;
    if (metadata != null) data['metadata'] = metadata;

    return data;
  }
}
