import 'package:starnest/features/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.userId,
    required super.sessionId,
    required super.token,
    super.isNewUser,
    super.firstName,
    super.lastName,
    super.email,
    super.avatarUrl,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};

    final userId =
        user['_id']?.toString() ??
        user['id']?.toString() ??
        json['userId']?.toString() ??
        json['_id']?.toString() ??
        json['id']?.toString() ??
        '';

    final sessionId =
        json['sessionId']?.toString() ?? user['sessionId']?.toString() ?? '';

    final token = json['token']?.toString() ?? '';
    final isNewUser = json['isNewUser'] as bool? ?? false;

    return AuthModel(
      userId: userId,
      sessionId: sessionId,
      token: token,
      isNewUser: isNewUser,
      firstName: user['firstName']?.toString(),
      lastName: user['lastName']?.toString(),
      email: user['email']?.toString() ?? json['email']?.toString(),
      avatarUrl:
          user['profileImage']?.toString() ??
          user['avatarUrl']?.toString() ??
          json['avatarUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'sessionId': sessionId,
    'token': token,
    'isNewUser': isNewUser,
    if (firstName != null) 'firstName': firstName,
    if (lastName != null) 'lastName': lastName,
    if (email != null) 'email': email,
    if (avatarUrl != null) 'avatarUrl': avatarUrl,
  };

  factory AuthModel.fromCache(Map<String, String?> cache) {
    return AuthModel(
      userId: cache['userId'] ?? '',
      sessionId: cache['sessionId'] ?? '',
      token: cache['token'] ?? '',
      isNewUser: false,
      firstName: cache['firstName'],
      lastName: cache['lastName'],
      email: cache['email'],
      avatarUrl: cache['avatarUrl'],
    );
  }
}
