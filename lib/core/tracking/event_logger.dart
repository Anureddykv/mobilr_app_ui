import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class EventLogger {
  static const String _tag = '🌟 StarNest Tracker';

  static void logRequest(String endpoint, Map<String, dynamic> body) {
    _log('POST $endpoint | BODY: $body');
  }

  static void logResponse(String endpoint, int? statusCode) {
    _log('POST $endpoint → ${statusCode ?? 'UNKNOWN'} OK');
  }

  static void logError(String endpoint, dynamic error) {
    _log('❌ ERROR $endpoint → $error');
  }

  static void logEvent(String eventType, Map<String, dynamic> payload) {
    final target = payload['target_type'] ?? 'unknown';
    final id = payload['target_id'] ?? 'unknown';
    _log('EVENT: $eventType | TARGET: $target | ID: $id');
  }

  static void _log(String message) {
    if (kDebugMode) {
      developer.log('$_tag | $message', name: 'starnest.tracker');
    }
  }
}
