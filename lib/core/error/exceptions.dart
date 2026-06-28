/// Thrown when the remote server returns an unexpected response or non-2xx
/// status code.
class ServerException implements Exception {
  const ServerException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Thrown when there is no network connectivity.
class NetworkException implements Exception {
  const NetworkException({this.message = 'No internet connection.'});

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

/// Thrown when reading from or writing to the local cache (SharedPreferences)
/// fails.
class CacheException implements Exception {
  const CacheException({required this.message});

  final String message;

  @override
  String toString() => 'CacheException: $message';
}

/// Thrown during authentication-specific failures (e.g. Google sign-in
/// cancelled, Firebase token missing, backend rejected credentials).
class AuthException implements Exception {
  const AuthException({required this.message});

  final String message;

  @override
  String toString() => 'AuthException: $message';
}
