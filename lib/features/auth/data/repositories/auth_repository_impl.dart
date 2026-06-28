import 'dart:developer';

import 'package:starnest/core/error/exceptions.dart';
import 'package:starnest/core/error/result.dart';
import 'package:starnest/core/network/network_info.dart';
import 'package:starnest/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:starnest/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:starnest/features/auth/data/models/auth_model.dart';
import 'package:starnest/features/auth/domain/entities/auth_entity.dart';
import 'package:starnest/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
    required AuthLocalDatasource localDatasource,
    required NetworkInfo networkInfo,
  }) : _remote = remoteDatasource,
       _local = localDatasource,
       _network = networkInfo;

  final AuthRemoteDatasource _remote;
  final AuthLocalDatasource _local;
  final NetworkInfo _network;

  // ---------------------------------------------------------------------------
  // Login with Email
  // ---------------------------------------------------------------------------

  @override
  Future<Result<AuthEntity, Failure>> loginWithEmail(
    String email,
    String password,
  ) async {
    if (!await _network.isConnected) {
      return const ResultFailure(NetworkFailure());
    }
    try {
      final model = await _remote.loginWithEmail(email, password);
      await _cacheAndReturn(model);
      return Success(model);
    } on ServerException catch (e) {
      return ResultFailure(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on CacheException catch (e) {
      log('[AuthRepository] Cache error after login: ${e.message}');
      // Login succeeded — return success even if caching fails
      return ResultFailure(CacheFailure(message: e.message));
    } catch (e) {
      return ResultFailure(ServerFailure(message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Signup
  // ---------------------------------------------------------------------------

  @override
  Future<Result<AuthEntity, Failure>> signup(SignupParams params) async {
    if (!await _network.isConnected) {
      return const ResultFailure(NetworkFailure());
    }
    try {
      final model = await _remote.signup(params);
      await _cacheAndReturn(model);
      return Success(model);
    } on ServerException catch (e) {
      return ResultFailure(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on CacheException catch (e) {
      log('[AuthRepository] Cache error after signup: ${e.message}');
      return ResultFailure(CacheFailure(message: e.message));
    } catch (e) {
      return ResultFailure(ServerFailure(message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Google Login
  // ---------------------------------------------------------------------------

  @override
  Future<Result<AuthEntity, Failure>> loginWithGoogle(
    String idToken,
    String platform,
  ) async {
    if (!await _network.isConnected) {
      return const ResultFailure(NetworkFailure());
    }
    try {
      final model = await _remote.loginWithGoogle(idToken, platform);
      await _cacheAndReturn(model);
      return Success(model);
    } on ServerException catch (e) {
      return ResultFailure(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on CacheException catch (e) {
      log('[AuthRepository] Cache error after Google login: ${e.message}');
      return ResultFailure(CacheFailure(message: e.message));
    } catch (e) {
      return ResultFailure(ServerFailure(message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Logout
  // ---------------------------------------------------------------------------

  @override
  Future<Result<void, Failure>> logout(String userId, String sessionId) async {
    // Clear local session regardless of network state.
    try {
      await _local.clearSession();
    } on CacheException catch (e) {
      log('[AuthRepository] Cache clear error on logout: ${e.message}');
    }

    if (!await _network.isConnected) {
      // Local already cleared — report network failure but don't block the user.
      return const ResultFailure(NetworkFailure());
    }

    try {
      await _remote.logout(userId, sessionId);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultFailure(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } catch (e) {
      return ResultFailure(ServerFailure(message: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<void> _cacheAndReturn(AuthModel model) async {
    await _local.cacheSession(model);
  }
}
