class Settings {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool inAppNotifications;
  final bool doNotDisturb;
  final NotificationPreferences notificationPreferences;

  Settings({
    required this.pushNotifications,
    required this.emailNotifications,
    required this.inAppNotifications,
    required this.doNotDisturb,
    required this.notificationPreferences,
  });

  Settings copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? inAppNotifications,
    bool? doNotDisturb,
    NotificationPreferences? notificationPreferences,
  }) {
    return Settings(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      inAppNotifications: inAppNotifications ?? this.inAppNotifications,
      doNotDisturb: doNotDisturb ?? this.doNotDisturb,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
    );
  }
}

class NotificationPreferences {
  final bool likes;
  final bool replies;
  final bool followers;
  final bool interests;

  NotificationPreferences({
    required this.likes,
    required this.replies,
    required this.followers,
    required this.interests,
  });

  NotificationPreferences copyWith({
    bool? likes,
    bool? replies,
    bool? followers,
    bool? interests,
  }) {
    return NotificationPreferences(
      likes: likes ?? this.likes,
      replies: replies ?? this.replies,
      followers: followers ?? this.followers,
      interests: interests ?? this.interests,
    );
  }
}
