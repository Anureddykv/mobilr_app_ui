import 'dart:developer';

import 'package:dio/dio.dart';
import 'event_logger.dart';
import 'models/track_event.dart';

class TrackingClient {
  static final TrackingClient instance = TrackingClient._internal();
  
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://flutter-backend-qsz8.onrender.com',
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  String? _authToken;
  String? _userId;

  TrackingClient._internal();

  void setAuth(String token, String userId) {
    _authToken = token;
    _userId = userId;
  }

  void clearAuth() {
    _authToken = null;
    _userId = null;
  }

  String? get userId => _userId;

  Future<void> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final options = Options(headers: {});
      log("Bearer $_authToken");
      if (_authToken != null) {
        options.headers!['Authorization'] = 'Bearer $_authToken';
      }

      EventLogger.logRequest(endpoint, body);
      
      final response = await _dio.post(
        endpoint,
        data: body,
        options: options,
      );

      EventLogger.logResponse(endpoint, response.statusCode);
    } catch (e) {
      EventLogger.logError(endpoint, e);
      // Tracking must never crash the app
    }
  }

  Future<void> delete(String endpoint, Map<String, dynamic> body) async {
    try {
      final options = Options(headers: {});
      if (_authToken != null) {
        options.headers!['Authorization'] = 'Bearer $_authToken';
      }

      EventLogger.logRequest(endpoint, body);
      
      final response = await _dio.delete(
        endpoint,
        data: body,
        options: options,
      );

      EventLogger.logResponse(endpoint, response.statusCode);
    } catch (e) {
      EventLogger.logError(endpoint, e);
    }
  }

  Future<void> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final options = Options(headers: {});
      if (_authToken != null) {
        options.headers!['Authorization'] = 'Bearer $_authToken';
      }

      EventLogger.logRequest(endpoint, body);
      
      final response = await _dio.put(
        endpoint,
        data: body,
        options: options,
      );

      EventLogger.logResponse(endpoint, response.statusCode);
    } catch (e) {
      EventLogger.logError(endpoint, e);
    }
  }

  Future<void> postEvent(TrackEvent event) async {
    await post('/api/events', event.toJson());
  }
}
