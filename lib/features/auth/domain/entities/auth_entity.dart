/// Pure domain entity representing an authenticated user session.
///
/// This class has **no dependency on Flutter, Dio, Firebase, or JSON**.
/// It is the contract between the data and presentation layers.
class AuthEntity {
  const AuthEntity({
    required this.userId,
    required this.sessionId,
    required this.token,
    this.isNewUser = false,
    this.firstName,
    this.lastName,
    this.email,
    this.avatarUrl,
  });

  /// Backend MongoDB `_id` (or equivalent primary key).
  final String userId;

  /// Backend-generated session identifier (e.g. `ses_XXXXXX`).
  final String sessionId;

  /// JWT / bearer token returned by the backend.
  final String token;

  /// True when this is the user's first sign-in (relevant for onboarding flow).
  final bool isNewUser;

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? avatarUrl;

  @override
  String toString() =>
      'AuthEntity(userId: $userId, sessionId: $sessionId, isNewUser: $isNewUser)';
}
