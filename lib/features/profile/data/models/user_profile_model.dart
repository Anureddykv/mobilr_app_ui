import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  UserProfileModel({
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.avatarUrl,
    required super.interests,
    required super.myLists,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      interests: Map<String, List<String>>.from(
        json['interests'] ?? {},
      ),
      myLists: Map<String, List<String>>.from(
        json['myLists'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'avatarUrl': avatarUrl,
      'interests': interests,
      'myLists': myLists,
    };
  }

  UserProfile toEntity() {
    return UserProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      avatarUrl: avatarUrl,
      interests: interests,
      myLists: myLists,
    );
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      avatarUrl: entity.avatarUrl,
      interests: entity.interests,
      myLists: entity.myLists,
    );
  }
}
