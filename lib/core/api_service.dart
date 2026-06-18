import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  late Dio _dio;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL']!,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log('🚀 REQUEST');
          log('URL: ${options.baseUrl}${options.path}');
          log('METHOD: ${options.method}');
          log('HEADERS: ${options.headers}');
          log('BODY: ${options.data}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          log('✅ RESPONSE');
          log('URL: ${response.requestOptions.path}');
          log('STATUS: ${response.statusCode}');
          log('DATA: ${response.data}');
          handler.next(response);
        },
        onError: (DioException e, handler) {
          log('❌ ERROR');
          log('URL: ${e.requestOptions.path}');
          log('STATUS: ${e.response?.statusCode}');
          log('MESSAGE: ${e.message}');
          log('DATA: ${e.response?.data}');
          handler.next(e);
        },
      ),
    );
  }

  // Generic list fetcher
  Future<List<dynamic>> fetchList(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      if (response.statusCode == 200) {
        if (response.data is List) {
          return response.data as List<dynamic>;
        } else if (response.data is Map && response.data['data'] is List) {
          return response.data['data'] as List<dynamic>;
        }
      }
      return [];
    } catch (e) {
      log("API Error [$endpoint]: $e");
      return [];
    }
  }

  // Auth: Signup
  // Returns a normalised map with keys: 'userId', 'sessionId', 'token'
  Future<Map<String, dynamic>?> signup(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post('/api/users/signup', data: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        final user = data['user'] as Map<String, dynamic>? ?? data;
        return {
          'token': data['token'] ?? '',
          'userId': user['_id']?.toString() ?? user['id']?.toString() ?? '',
          'sessionId':
              data['sessionId']?.toString() ??
              user['sessionId']?.toString() ??
              data['token']?.toString() ??
              '',
          // Keep raw data accessible if needed
          'raw': data,
        };
      }
    } catch (e) {
      log("Signup Error: $e");
    }
    return null;
  }

  // Auth: Email/Password Login
  // Returns a normalised map with keys: 'userId', 'sessionId', 'token'
  // The backend wraps user data inside response.data['user'].
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/users/login',
        data: {"email": email, "password": password},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        // Backend shape: { token, user: { _id, sessionId, ... } }
        final user = data['user'] as Map<String, dynamic>? ?? data;
        return {
          'token': data['token'] ?? '',
          'userId': user['_id']?.toString() ?? user['id']?.toString() ?? '',
          'sessionId':
              data['sessionId']?.toString() ??
              user['sessionId']?.toString() ??
              '',
          // Keep raw data accessible if needed
          'raw': data,
        };
      }
    } catch (e) {
      log("Login Error: $e");
    }
    return null;
  }

  // Auth: Google Login — exchanges a Firebase ID Token for a backend session.
  // Endpoint: POST /auth/google
  // Body: { "idToken": <firebase_id_token>, "platform": "android"|"ios" }
  // Returns a normalised map with keys: 'userId', 'sessionId'
  Future<Map<String, dynamic>?> googleLogin({
    required String idToken,
    required String platform,
  }) async {
    try {
      log('🔥 Google Login Started');
      log('Platform: $platform');
      log('ID Token Length: ${idToken.length}');
      log('ID Token Preview: ${idToken.substring(0, 20)}...');

      final response = await _dio.post(
        '/auth/google',
        data: {"idToken": idToken, "platform": platform},
      );

      log('🔥 Google Login Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        final user = data['user'] as Map<String, dynamic>? ?? data;

        return {
          'userId':
              user['_id']?.toString() ??
              user['id']?.toString() ??
              data['userId']?.toString() ??
              '',
          'sessionId':
              data['sessionId']?.toString() ??
              user['sessionId']?.toString() ??
              '',
          'isNewUser': data['isNewUser'] as bool? ?? false,
          'raw': data,
        };
      }
    } catch (e, stackTrace) {
      log('Google Login Error', error: e, stackTrace: stackTrace);
    }
    return null;
  }

  // Auth: Logout – clears the server-side session
  Future<void> logout({
    required String userId,
    required String sessionId,
  }) async {
    try {
      await _dio.post(
        '/api/users/logout',
        data: {"user_id": userId, "session_id": sessionId},
      );
    } catch (e) {
      log("Logout Error: $e");
    }
  }
}
