import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:starnest/app/config/app_config.dart';
import 'package:starnest/core/error/exceptions.dart';
import 'package:starnest/core/managers/shared_preference_manager.dart';

/// Central Dio singleton.
///
/// Responsibilities:
///  - Base URL + timeout configuration (from [AppConfig])
///  - Auth-token injection on every request
///  - Request / response / error logging
///  - Mapping [DioException] → typed [ServerException]
///
/// **No business logic lives here.** Datasources call the raw [get], [post],
/// [put], [delete] methods and interpret the response data themselves.
class DioClient {
  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([_tokenInterceptor, _loggingInterceptor]);
  }

  static final DioClient instance = DioClient._internal();

  late final Dio _dio;

  // ---------------------------------------------------------------------------
  // Token injection interceptor
  // ---------------------------------------------------------------------------

  final _tokenInterceptor = InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = SharedPreferenceManager.instance.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
  );

  // ---------------------------------------------------------------------------
  // Logging interceptor
  // ---------------------------------------------------------------------------

  final _loggingInterceptor = InterceptorsWrapper(
    onRequest: (options, handler) {
      log('┌── 🚀 REQUEST ──────────────────────────────────');
      log('│ ${options.method} ${options.baseUrl}${options.path}');
      log('│ Headers: ${options.headers}');
      if (options.data != null) log('│ Body: ${options.data}');
      log('└────────────────────────────────────────────────');
      handler.next(options);
    },
    onResponse: (response, handler) {
      log('┌── ✅ RESPONSE ─────────────────────────────────');
      log('│ ${response.statusCode} ${response.requestOptions.path}');
      log('│ Data: ${response.data}');
      log('└────────────────────────────────────────────────');
      handler.next(response);
    },
    onError: (DioException e, handler) {
      log('┌── ❌ ERROR ─────────────────────────────────────');
      log('│ ${e.requestOptions.method} ${e.requestOptions.path}');
      log('│ Status: ${e.response?.statusCode}');
      log('│ Message: ${e.message}');
      if (e.response?.data != null) log('│ Data: ${e.response?.data}');
      log('└────────────────────────────────────────────────');
      handler.next(e);
    },
  );

  // ---------------------------------------------------------------------------
  // Public HTTP methods
  // ---------------------------------------------------------------------------

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Error mapping
  // ---------------------------------------------------------------------------

  ServerException _mapDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    String message;
    if (data is Map && data['message'] != null) {
      message = data['message'].toString();
    } else if (data is Map && data['error'] != null) {
      message = data['error'].toString();
    } else if (e.message != null && e.message!.isNotEmpty) {
      message = e.message!;
    } else {
      message = 'An unexpected server error occurred.';
    }

    return ServerException(message: message, statusCode: statusCode);
  }
}
