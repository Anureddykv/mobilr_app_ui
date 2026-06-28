import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfile {
  final ProfileRepository repository;

  UpdateUserProfile(this.repository);

  Future<void> call(UserProfile profile) {
    return repository.updateUserProfile(profile);
  }
}
