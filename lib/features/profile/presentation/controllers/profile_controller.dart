import 'package:get/get.dart';
import 'package:starnest/core/service/user_session.dart';
import 'package:starnest/features/profile/domain/entities/user_profile.dart';
import 'package:starnest/features/profile/domain/usecases/get_user_profile.dart';
import 'package:starnest/features/profile/domain/usecases/update_user_profile.dart';
import 'package:starnest/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:starnest/features/profile/data/repositories_impl/profile_repository_impl.dart';

class ProfileController extends GetxController {
  late final Rx<UserProfile> userProfile;
  late final GetUserProfile getUserProfileUseCase;
  late final UpdateUserProfile updateUserProfileUseCase;

  @override
  void onInit() {
    super.onInit();

    // Initialize dependencies
    final localDataSource = ProfileLocalDataSourceImpl();
    final repository = ProfileRepositoryImpl(localDataSource: localDataSource);
    getUserProfileUseCase = GetUserProfile(repository);
    updateUserProfileUseCase = UpdateUserProfile(repository);

    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await getUserProfileUseCase();

      // Override with session data if available
      final session = UserSession.instance;
      final fName = session.firstName ?? profile.firstName;
      final lName = session.lastName ?? profile.lastName;
      final email = session.email ?? profile.email;
      final avatar = session.avatarUrl ?? profile.avatarUrl;

      final String initial = fName.isNotEmpty
          ? fName[0].toUpperCase()
          : (email.isNotEmpty ? email[0].toUpperCase() : 'U');
      final fallbackAvatar =
          "https://placehold.co/72x72/FFFFFF/000000?text=$initial";

      userProfile = profile
          .copyWith(
            firstName: fName.isNotEmpty ? fName : profile.firstName,
            lastName: lName.isNotEmpty ? lName : profile.lastName,
            email: email.isNotEmpty ? email : profile.email,
            avatarUrl: avatar.isNotEmpty ? avatar : fallbackAvatar,
          )
          .obs;
    } catch (e) {
      // Fallback to default profile if loading fails
      userProfile = UserProfile(
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
      ).obs;
    }
  }

  void addTypeToMyLists(String newType) {
    if (newType.isNotEmpty && !userProfile.value.myLists.containsKey(newType)) {
      final updatedLists = Map<String, List<String>>.from(
        userProfile.value.myLists,
      );
      updatedLists[newType] = [];
      final updatedProfile = userProfile.value.copyWith(myLists: updatedLists);
      userProfile.value = updatedProfile;

      // Persist the updated profile
      updateUserProfileUseCase(updatedProfile);
    }
  }
}
