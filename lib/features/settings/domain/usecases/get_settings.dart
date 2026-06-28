import '../entities/settings.dart';
import '../repositories/settings_repository.dart';

class GetSettings {
  final SettingsRepository repository;

  GetSettings(this.repository);

  Future<Settings> call() {
    return repository.getSettings();
  }
}
