import '../models/user_profile_model.dart';

abstract class ProfileLocalDataSource {
  UserProfileModel getUserProfile();
  Future<void> cacheUserProfile(UserProfileModel profile);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  @override
  UserProfileModel getUserProfile() {
    // This would typically read from local storage (SharedPreferences, Hive, etc.)
    // For now, returning a default model
    return UserProfileModel(
      firstName: 'Rohit',
      lastName: 'Parvathala',
      email: 'example@gmail.com',
      avatarUrl: '',
      interests: {
        'Movies': ['Action', 'Thriller', 'Telugu', 'Prabhas', 'NTR', 'RDJ'],
        'Books': ['Fiction', 'Self Help', 'Fantasy'],
        'Cuisines': ['Chinese', 'South India', 'South American'],
      },
      myLists: {
        'Movies': ["https://placehold.co/120x120/E05473/000000?text=RRR", ""],
        'Books': ["https://placehold.co/120x120/54E0A1/000000?text=Ikigai"],
        'Games': ["https://placehold.co/120x120/8B54E0/000000?text=GTA+VI"],
      },
    );
  }

  @override
  Future<void> cacheUserProfile(UserProfileModel profile) async {
    // This would typically save to local storage
    // Implementation depends on the storage solution used
  }
}
