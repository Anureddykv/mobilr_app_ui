import '../../domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../data_sources/settings_local_data_source.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Settings> getSettings() async {
    final settingsModel = localDataSource.getSettings();
    return settingsModel.toEntity();
  }

  @override
  Future<void> updateSettings(Settings settings) async {
    final settingsModel = SettingsModel.fromEntity(settings);
    await localDataSource.cacheSettings(settingsModel);
  }
}
