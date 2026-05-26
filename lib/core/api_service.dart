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
    _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
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
  Future<Map<String, dynamic>?> signup(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post('/api/users/signup', data: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      log("Signup Error: $e");
    }
    return null;
  }

  // Auth: Login
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _dio.post('/api/users/login', data: {
        "email": email,
        "password": password,
      });
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      log("Login Error: $e");
    }
    return null;
  }
}

