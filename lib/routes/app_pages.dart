import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starnest/features/splash/presentation/screens/splash_screen_loading.dart';
import 'package:starnest/features/auth/presentation/screens/credential_screen_signin.dart';
import 'package:starnest/features/auth/presentation/screens/credential_screen_signin_starnest.dart';
import 'package:starnest/features/auth/presentation/screens/credential_screen_signup.dart';
import 'package:starnest/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:starnest/features/onboarding/presentation/screens/onboarding_interests_screen.dart';
import 'package:starnest/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:starnest/features/profile/presentation/screens/profile_screen.dart';
import 'package:starnest/features/search/presentation/screens/search_screen.dart';
import 'package:starnest/features/notification/presentation/screens/notification_screen.dart';
import 'package:starnest/features/settings/presentation/screens/settings_screen.dart';
import 'package:starnest/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:starnest/features/settings/presentation/screens/admin_screen_adding_new_title.dart';
import 'package:starnest/features/review/presentation/screens/add_edit_review_screen.dart';
import 'package:starnest/features/chat/presentation/screens/comments_screen.dart';
import 'package:starnest/features/chat/presentation/screens/features_screen_community.dart';
import 'app_routes.dart';

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
      page: () => OnboardingScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.onboardingInterests,
      page: () => OnboardingInterestsScreen(),
      transition: Transition.rightToLeft,
    ),

    // -------------------------------------------------------------------------
    // Home / Shell
    // -------------------------------------------------------------------------
    GetPage(
      name: AppRoutes.home,
      page: () => const DashboardScreen(),
      transition: Transition.fade,
    ),

    // -------------------------------------------------------------------------
    // Review
    // -------------------------------------------------------------------------
    GetPage(
      name: AppRoutes.addReview,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        return AddEditReviewScreen(
          itemName: args?['itemName'] ?? '',
          itemType: args?['itemType'] ?? 'Item',
          initialRating: args?['initialRating'] ?? 0.0,
          accentColor: args?['accentColor'] ?? const Color(0xFF54B6E0),
          ratingAssetPath: args?['ratingAssetPath'] ?? "assets/images/sd.png",
        );
      },
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
      page: () => NotificationScreen(),
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
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        return CommentsScreen(
          itemTitle: args?['itemTitle'] ?? '',
          comments: args?['comments'] ?? const [],
          iconAssetPath: args?['iconAssetPath'] ?? "assets/images/restaurants.png",
          iconColor: args?['iconColor'] ?? const Color(0xFF54B6E0),
        );
      },
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.featuresCommunity,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        return FeaturesScreenCommunity(
          communityId: args?['communityId'] ?? '',
          communityName: args?['communityName'] ?? '',
          communityImageUrl: args?['communityImageUrl'] ?? '',
        );
      },
      transition: Transition.rightToLeft,
    ),
  ];
}
