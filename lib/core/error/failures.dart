/// Abstract base for all domain-layer failures.
///
/// Failures are what the presentation layer receives — they are converted
/// from [Exception]s inside the repository implementation and carry a
/// human-readable [message] that can be shown to the user.
abstract class Failure {
  const Failure({required this.message});

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The remote API returned an error or unexpected response.
class ServerFailure extends Failure {
  const ServerFailure({required super.message, this.statusCode});

  final int? statusCode;
}

/// The device has no active network connection.
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection.'});
}

/// Reading from or writing to the local cache (SharedPreferences) failed.
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// An authentication-specific failure (e.g. Google sign-in cancelled, invalid
/// credentials, Firebase token missing).
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}
