import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starnest/features/splash/presentation/bindings/splash_binding.dart';
import 'package:starnest/features/splash/presentation/pages/onboarding_screen.dart';
import 'package:starnest/features/splash/presentation/pages/splash_screen.dart';
import 'package:starnest/features/auth/presentation/bindings/auth_binding.dart';
import 'package:starnest/features/auth/presentation/pages/login_option_screen.dart';
import 'package:starnest/features/auth/presentation/pages/login_screen.dart';
import 'package:starnest/features/auth/presentation/pages/signup_screen.dart';
import 'package:starnest/features/auth/presentation/pages/user_interest_screen.dart';
import 'package:starnest/features/auth/presentation/pages/user_preference_screen.dart';
import 'package:starnest/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:starnest/features/profile/presentation/pages/profile_screen.dart';
import 'package:starnest/features/search/presentation/pages/search_screen.dart';
import 'package:starnest/features/notification/presentation/pages/notification_screen.dart';
import 'package:starnest/features/settings/presentation/pages/settings_screen.dart';
import 'package:starnest/features/settings/presentation/pages/privacy_policy_screen.dart';
import 'package:starnest/features/settings/presentation/pages/admin_screen_adding_new_title.dart';
import 'package:starnest/features/review/presentation/pages/add_edit_review_screen.dart';
import 'package:starnest/features/chat/presentation/pages/comments_screen.dart';
import 'package:starnest/features/chat/presentation/pages/features_screen_community.dart';
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
      binding: SplashBinding(),
      transition: Transition.fade,
    ),

    // -------------------------------------------------------------------------
    // Auth
    // -------------------------------------------------------------------------
    GetPage(
      name: AppRoutes.loginOption,
      page: () => const LoginOptionScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.signinStarnest,
      page: () => const SignInScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignUpScreen(),
      binding: AuthBinding(),
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
      name: AppRoutes.userInterest,
      page: () => UserInterestScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.userPreference,
      page: () => UserPreferenceScreen(),
      binding: AuthBinding(),
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
          ratingAssetPath: args?['ratingAssetPath'] ?? 'assets/images/sd.png',
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
          iconAssetPath:
              args?['iconAssetPath'] ?? 'assets/images/restaurants.png',
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
