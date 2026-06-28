// This file is deprecated. Use [DioClient] from `core/api/dio_client.dart`
// and feature-specific datasources instead.
//
// Keeping this stub so other parts of the codebase that haven't been migrated
// yet do not break. Remove once all callers are updated.

import 'package:starnest/core/api/dio_client.dart';

@Deprecated('Use DioClient + feature datasources instead.')
class ApiService {
  @Deprecated('Use DioClient + feature datasources instead.')
  static final ApiService _instance = ApiService._internal();

  @Deprecated('Use DioClient + feature datasources instead.')
  factory ApiService() => _instance;

  ApiService._internal();
  final DioClient _dio = DioClient.instance;
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
      return [];
    }
  }
}
