class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String avatarUrl;
  final Map<String, List<String>> interests;
  final Map<String, List<String>> myLists;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatarUrl,
    required this.interests,
    required this.myLists,
  });

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? avatarUrl,
    Map<String, List<String>>? interests,
    Map<String, List<String>>? myLists,
  }) {
    return UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      interests: interests ?? this.interests,
      myLists: myLists ?? this.myLists,
    );
  }
}
