import 'package:get/get.dart';
import 'package:starnest/splash/SplashScreenLoading.dart';
import 'package:starnest/signinup/CredentialScreenSignin.dart';
import 'package:starnest/signinup/CredentialScreenSigninStarnest.dart';
import 'package:starnest/signinup/CredentialScreenSignup.dart';
import 'package:starnest/onbording/onboarding_screen.dart';
import 'package:starnest/onbording/onboarding_interests_screen.dart';
import 'package:starnest/home/screens/home_screen.dart';
import 'package:starnest/bottomnav/profile_screen.dart';
import 'package:starnest/bottomnav/search_screen.dart';
import 'package:starnest/bottomnav/notification_screen.dart';
import 'package:starnest/settings/settings_screen.dart';
import 'package:starnest/settings/privacy_policy_screen.dart';
import 'package:starnest/settings/admin_screen_adding_new_title.dart';
import 'package:starnest/review/add_edit_review_screen.dart';
import 'package:starnest/chat/comments_screen.dart';
import 'package:starnest/chat/features_screen_community.dart';
import 'app_routes.dart';
// NOTE: Above imports will resolve once screen files are migrated and use `package:starnest/...`
// Until then, these are stubs showing intended routing structure.

/// GetX page configuration list.
/// Pass this to [GetMaterialApp.getPages].
class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    // -------------------------------------------------------------------------
    // Splash
    // -------------------------------------------------------------------------
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fade,
    ),

    // -------------------------------------------------------------------------
    // Auth
    // -------------------------------------------------------------------------
    GetPage(
      name: AppRoutes.signin,
      page: () => const CredentialScreenSignin(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.signinStarnest,
      page: () => const CredentialScreenSigninStarnest(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => CredentialScreenSignup(),
      transition: Transition.rightToLeft,
    ),

    // -------------------------------------------------------------------------
    // Onboarding
    // -------------------------------------------------------------------------
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.onboardingInterests,
      page: () => OnboardingInterestsScreen(),
      transition: Transition.rightToLeft,
    ),

    // -------------------------------------------------------------------------
    // Home
    // -------------------------------------------------------------------------
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      transition: Transition.fade,
    ),

    // -------------------------------------------------------------------------
    // Review
    // -------------------------------------------------------------------------
    GetPage(
      name: AppRoutes.addReview,
      page: () => const AddEditReviewScreen(),
      transition: Transition.downToUp,
    ),

    // -------------------------------------------------------------------------
    // Profile / Bottom Nav
    // -------------------------------------------------------------------------
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationScreen(),
      transition: Transition.rightToLeft,
    ),

    // -------------------------------------------------------------------------
    // Settings
    // -------------------------------------------------------------------------
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.adminAddTitle,
      page: () => const AdminScreenAddingNewTitle(),
      transition: Transition.rightToLeft,
    ),

    // -------------------------------------------------------------------------
    // Chat / Community
    // -------------------------------------------------------------------------
    GetPage(
      name: AppRoutes.comments,
      page: () => const CommentsScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.featuresCommunity,
      page: () => const FeaturesScreenCommunity(),
      transition: Transition.rightToLeft,
    ),
  ];
}
