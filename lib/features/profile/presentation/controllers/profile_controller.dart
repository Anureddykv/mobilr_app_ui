import 'package:get/get.dart';
import 'package:starnest/core/service/user_session.dart';

class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String avatarUrl;
  final Map<String, List<String>> interests;
  final Map<String, List<String>> myLists;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatarUrl,
    required this.interests,
    required this.myLists,
  });
}

class ProfileController extends GetxController {
  late final Rx<UserProfile> userProfile;

  @override
  void onInit() {
    super.onInit();
    final session = UserSession.instance;
    final fName = session.firstName ?? '';
    final lName = session.lastName ?? '';
    final email = session.email ?? '';
    final avatar = session.avatarUrl ?? '';

    final String initial = fName.isNotEmpty
        ? fName[0].toUpperCase()
        : (email.isNotEmpty ? email[0].toUpperCase() : 'U');
    final fallbackAvatar =
        "https://placehold.co/72x72/FFFFFF/000000?text=$initial";

    userProfile = UserProfile(
      firstName: fName.isNotEmpty ? fName : "Rohit",
      lastName: lName.isNotEmpty ? lName : "Parvathala",
      email: email.isNotEmpty ? email : "example@gmail.com",
      avatarUrl: avatar.isNotEmpty ? avatar : fallbackAvatar,
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

  void addTypeToMyLists(String newType) {
    if (newType.isNotEmpty && !userProfile.value.myLists.containsKey(newType)) {
      final updatedLists = Map<String, List<String>>.from(
        userProfile.value.myLists,
      );
      updatedLists[newType] = [];
      userProfile.value = UserProfile(
        firstName: userProfile.value.firstName,
        lastName: userProfile.value.lastName,
        email: userProfile.value.email,
        avatarUrl: userProfile.value.avatarUrl,
        interests: userProfile.value.interests,
        myLists: updatedLists,
      );
    }
  }
}
