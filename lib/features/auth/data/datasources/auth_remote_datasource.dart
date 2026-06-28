import 'package:starnest/core/api/api_endpoints.dart';
import 'package:starnest/core/api/dio_client.dart';
import 'package:starnest/core/error/exceptions.dart';
import 'package:starnest/features/auth/data/models/auth_model.dart';
import 'package:starnest/features/auth/domain/repositories/auth_repository.dart';

abstract class AuthRemoteDatasource {
  Future<AuthModel> loginWithEmail(String email, String password);
  Future<AuthModel> signup(SignupParams params);
  Future<AuthModel> loginWithGoogle(String idToken, String platform);
  Future<void> logout(String userId, String sessionId);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  const AuthRemoteDatasourceImpl(this._client);

  final DioClient _client;

  @override
  Future<AuthModel> loginWithEmail(String email, String password) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException(
        message: 'Empty response from login endpoint.',
      );
    }
    return AuthModel.fromJson(data);
  }

  @override
  Future<AuthModel> signup(SignupParams params) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.signup,
      data: {
        'firstName': params.firstName,
        'lastName': params.lastName,
        'email': params.email,
        'phone': params.phone,
        'password': params.password,
      },
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException(
        message: 'Empty response from signup endpoint.',
      );
    }
    return AuthModel.fromJson(data);
  }

  @override
  Future<AuthModel> loginWithGoogle(String idToken, String platform) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.googleLogin,
      data: {'idToken': idToken, 'platform': platform},
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException(
        message: 'Empty response from Google login endpoint.',
      );
    }
    return AuthModel.fromJson(data);
  }

  @override
  Future<void> logout(String userId, String sessionId) async {
    await _client.post<void>(
      ApiEndpoints.logout,
      data: {'user_id': userId, 'session_id': sessionId},
    );
  }
}
