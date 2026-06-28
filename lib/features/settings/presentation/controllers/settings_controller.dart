import 'package:get/get.dart';
import 'package:starnest/features/settings/domain/entities/settings.dart';
import 'package:starnest/features/settings/domain/usecases/get_settings.dart';
import 'package:starnest/features/settings/domain/usecases/update_settings.dart';
import 'package:starnest/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:starnest/features/settings/data/repositories_impl/settings_repository_impl.dart';

class SettingsController extends GetxController {
  final Rx<Settings> settings = Rx(Settings(
    pushNotifications: true,
    emailNotifications: false,
    inAppNotifications: true,
    doNotDisturb: false,
    notificationPreferences: NotificationPreferences(
      likes: true,
      replies: false,
      followers: true,
      interests: false,
    ),
  ));

  late final GetSettings getSettingsUseCase;
  late final UpdateSettings updateSettingsUseCase;

  @override
  void onInit() {
    super.onInit();
    
    // Initialize dependencies
    final localDataSource = SettingsLocalDataSourceImpl();
    final repository = SettingsRepositoryImpl(localDataSource: localDataSource);
    getSettingsUseCase = GetSettings(repository);
    updateSettingsUseCase = UpdateSettings(repository);

    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final loadedSettings = await getSettingsUseCase();
      settings.value = loadedSettings;
    } catch (e) {
      // Handle error - keep default settings
    }
  }

  Future<void> updatePushNotifications(bool value) async {
    final updated = settings.value.copyWith(pushNotifications: value);
    settings.value = updated;
    await updateSettingsUseCase(updated);
  }

  Future<void> updateEmailNotifications(bool value) async {
    final updated = settings.value.copyWith(emailNotifications: value);
    settings.value = updated;
    await updateSettingsUseCase(updated);
  }

  Future<void> updateInAppNotifications(bool value) async {
    final updated = settings.value.copyWith(inAppNotifications: value);
    settings.value = updated;
    await updateSettingsUseCase(updated);
  }

  Future<void> updateDoNotDisturb(bool value) async {
    final updated = settings.value.copyWith(doNotDisturb: value);
    settings.value = updated;
    await updateSettingsUseCase(updated);
  }

  Future<void> updateNotificationPreference(String key, bool value) async {
    final updatedPrefs = settings.value.notificationPreferences.copyWith(
      likes: key == 'likes' ? value : settings.value.notificationPreferences.likes,
      replies: key == 'replies' ? value : settings.value.notificationPreferences.replies,
      followers: key == 'followers' ? value : settings.value.notificationPreferences.followers,
      interests: key == 'interests' ? value : settings.value.notificationPreferences.interests,
    );
    final updated = settings.value.copyWith(notificationPreferences: updatedPrefs);
    settings.value = updated;
    await updateSettingsUseCase(updated);
  }
}
