import '../../domain/entities/settings.dart';

class SettingsModel extends Settings {
  SettingsModel({
    required super.pushNotifications,
    required super.emailNotifications,
    required super.inAppNotifications,
    required super.doNotDisturb,
    required super.notificationPreferences,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      pushNotifications: json['pushNotifications'] ?? true,
      emailNotifications: json['emailNotifications'] ?? false,
      inAppNotifications: json['inAppNotifications'] ?? true,
      doNotDisturb: json['doNotDisturb'] ?? false,
      notificationPreferences: NotificationPreferencesModel.fromJson(
        json['notificationPreferences'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pushNotifications': pushNotifications,
      'emailNotifications': emailNotifications,
      'inAppNotifications': inAppNotifications,
      'doNotDisturb': doNotDisturb,
      'notificationPreferences': notificationPreferences is NotificationPreferencesModel
          ? (notificationPreferences as NotificationPreferencesModel).toJson()
          : {},
    };
  }

  Settings toEntity() {
    return Settings(
      pushNotifications: pushNotifications,
      emailNotifications: emailNotifications,
      inAppNotifications: inAppNotifications,
      doNotDisturb: doNotDisturb,
      notificationPreferences: notificationPreferences,
    );
  }

  factory SettingsModel.fromEntity(Settings entity) {
    return SettingsModel(
      pushNotifications: entity.pushNotifications,
      emailNotifications: entity.emailNotifications,
      inAppNotifications: entity.inAppNotifications,
      doNotDisturb: entity.doNotDisturb,
      notificationPreferences: entity.notificationPreferences is NotificationPreferencesModel
          ? entity.notificationPreferences as NotificationPreferencesModel
          : NotificationPreferencesModel(
              likes: entity.notificationPreferences.likes,
              replies: entity.notificationPreferences.replies,
              followers: entity.notificationPreferences.followers,
              interests: entity.notificationPreferences.interests,
            ),
    );
  }
}

class NotificationPreferencesModel extends NotificationPreferences {
  NotificationPreferencesModel({
    required super.likes,
    required super.replies,
    required super.followers,
    required super.interests,
  });

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      likes: json['likes'] ?? true,
      replies: json['replies'] ?? false,
      followers: json['followers'] ?? true,
      interests: json['interests'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likes': likes,
      'replies': replies,
      'followers': followers,
      'interests': interests,
    };
  }
}
