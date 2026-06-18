import 'dart:developer';

import 'package:dio/dio.dart';
import 'event_logger.dart';
import 'models/track_event.dart';
import 'package:mobilr_app_ui/core/user_session.dart';

class TrackingClient {
  static final TrackingClient instance = TrackingClient._internal();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://flutter-backend-qsz8.onrender.com',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  String? _authToken;
  String? _userId;
  String? _sessionId;

  TrackingClient._internal();

  void setAuth(String token, String userId, {String? sessionId}) {
    _authToken = token;
    _userId = userId;
    _sessionId = sessionId;
  }

  void clearAuth() {
    _authToken = null;
    _userId = null;
    _sessionId = null;
  }

  String? get userId {
    if (_userId != null && _userId!.isNotEmpty) return _userId;
    // Fallback: use UserSession (handles restored sessions before token-persistence fix)
    final sid = UserSession.instance.userId;
    return (sid != null && sid.isNotEmpty) ? sid : null;
  }

  String? get sessionId {
    if (_sessionId != null && _sessionId!.isNotEmpty) return _sessionId;
    final sid = UserSession.instance.sessionId;
    return (sid != null && sid.isNotEmpty) ? sid : null;
  }

  Future<void> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final headers = <String, dynamic>{'Content-Type': 'application/json'};

      if (_authToken != null) {
        headers['Authorization'] = 'Bearer $_authToken';
      }

      final options = Options(headers: headers);

      EventLogger.logCurl(
        'POST',
        '${_dio.options.baseUrl}$endpoint',
        headers,
        body,
      );

      final response = await _dio.post(endpoint, data: body, options: options);

      EventLogger.logResponse(endpoint, response.statusCode, response.data);
    } on DioException catch (e) {
      EventLogger.logError(endpoint, e.message, e.response?.data);
    } catch (e) {
      EventLogger.logError(endpoint, e, null);
    }
  }

  Future<void> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final headers = <String, dynamic>{'Content-Type': 'application/json'};

      if (_authToken != null) {
        headers['Authorization'] = 'Bearer $_authToken';
      }

      final options = Options(headers: headers);

      EventLogger.logCurl(
        'PUT',
        '${_dio.options.baseUrl}$endpoint',
        headers,
        body,
      );

      final response = await _dio.put(endpoint, data: body, options: options);

      EventLogger.logResponse(endpoint, response.statusCode, response.data);
    } on DioException catch (e) {
      EventLogger.logError(endpoint, e.message, e.response?.data);
    } catch (e) {
      EventLogger.logError(endpoint, e, null);
    }
  }

  Future<void> delete(String endpoint, Map<String, dynamic> body) async {
    try {
      final headers = <String, dynamic>{'Content-Type': 'application/json'};

      if (_authToken != null) {
        headers['Authorization'] = 'Bearer $_authToken';
      }

      final options = Options(headers: headers);

      EventLogger.logCurl(
        'DELETE',
        '${_dio.options.baseUrl}$endpoint',
        headers,
        body,
      );

      final response = await _dio.delete(
        endpoint,
        data: body,
        options: options,
      );

      EventLogger.logResponse(endpoint, response.statusCode, response.data);
    } on DioException catch (e) {
      EventLogger.logError(endpoint, e.message, e.response?.data);
    } catch (e) {
      EventLogger.logError(endpoint, e, null);
    }
  }

  Future<void> postEvent(TrackEvent event) async {
    log('''
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 EVENT FIRED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

${event.eventType}

${event.toJson()}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
''', name: 'starnest.tracker');

    await post('/api/events', event.toJson());
  }
}
