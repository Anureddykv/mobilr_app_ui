import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_local_data_source.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({required this.localDataSource});

  @override
  Future<UserProfile> getUserProfile() async {
    final profileModel = localDataSource.getUserProfile();
    return profileModel.toEntity();
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    final profileModel = UserProfileModel.fromEntity(profile);
    await localDataSource.cacheUserProfile(profileModel);
  }
}
