import '../models/settings_model.dart';

abstract class SettingsLocalDataSource {
  SettingsModel getSettings();
  Future<void> cacheSettings(SettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsModel? _cachedSettings;

  @override
  SettingsModel getSettings() {
    // This would typically read from SharedPreferences
    // For now, returning default settings
    return _cachedSettings ?? SettingsModel(
      pushNotifications: true,
      emailNotifications: false,
      inAppNotifications: true,
      doNotDisturb: false,
      notificationPreferences: NotificationPreferencesModel(
        likes: true,
        replies: false,
        followers: true,
        interests: false,
      ),
    );
  }

  @override
  Future<void> cacheSettings(SettingsModel settings) async {
    _cachedSettings = settings;
    // This would typically save to SharedPreferences
  }
}
