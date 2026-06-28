import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:starnest/core/constants/app_images.dart';
import 'package:starnest/core/constants/color_palette.dart';
import 'package:starnest/core/extensions/context_ext.dart';
import 'package:starnest/core/extensions/num_ext.dart';
import 'package:starnest/core/extensions/text_style_ext.dart';
import 'package:starnest/core/service/auth_service.dart';
import 'package:starnest/features/auth/presentation/widget/term_condition_widget.dart';
import 'package:starnest/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:starnest/features/onboarding/presentation/pages/onboarding_interests_screen.dart';
import 'package:starnest/l10n/app_localizations.dart';
import 'package:starnest/ui/pages/splash_message_screen.dart';
import 'package:starnest/core/utils/snackbar_utils.dart';
import 'package:starnest/routes/app_routes.dart';
import 'package:starnest/ui/templates/common_scaffold.dart';
import 'package:starnest/ui/atoms/common_button.dart';
import 'package:starnest/ui/atoms/common_divider.dart';

class LoginOptionScreen extends StatefulWidget {
  const LoginOptionScreen({super.key});

  @override
  State<LoginOptionScreen> createState() => _LoginOptionScreenState();
}

class _LoginOptionScreenState extends State<LoginOptionScreen> {
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;
  bool _isAppleLoading = false;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return CommonScaffold(
      defaultPadding: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            strings.signInBeforeReview,
            style: TextStyles.s24.w600.generalSans
                .lhPercent(100)
                .cl(ColorPalette.white300),
            textAlign: TextAlign.center,
          ),
          24.verticalSpace,
          // Social Buttons (Starnest, Google)
          _buildSocialButtons(context, strings),

          16.verticalSpace,

          // Divider with "or"
          CommonDivider(text: strings.orDivider, color: ColorPalette.white400),

          16.verticalSpace,

          // Create Account Button
          CommonButton(
            padding: 12.paddingV,
            height: 48.h,
            label: strings.createAccount,
            backgroundColor: ColorPalette.white300,
            textStyle: TextStyles.s16.w600.generalSans
                .lhPercent(100)
                .cl(ColorPalette.grey800),
            onTap: () {
              context.pushNamed(AppRoutes.signup);
            },
          ),
          16.verticalSpace,

          // Terms and Conditions
          TermsAndCondition(strings: strings),
          const Spacer(),
          SvgPicture.asset(ImageRes.svgs.appTitleLogo),
          16.verticalSpace,
        ],
      ),
    );
  }

  // Real Google Sign-In handler using AuthService
  Future<void> _handleGoogleSignIn() async {
    if (_isGoogleLoading) return;
    setState(() => _isGoogleLoading = true);

    final result = await AuthService.instance.signInWithGoogle();

    if (!mounted) return;
    setState(() => _isGoogleLoading = false);

    if (result != null) {
      final isNewUser = result['isNewUser'] as bool? ?? false;
      if (isNewUser) {
        Get.put(OnboardingController());
        final strings = AppLocalizations.of(context)!;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SplashMessageScreen(
              title: strings.signupSuccess,
              circleColor: const Color(0xFF9DD870),
              backgroundColor: const Color(0xFF0B0B0B),
              headerImageUrl: "https://placehold.co/375x48",
              icon: const Icon(Icons.check, size: 48, color: Colors.black),
              nextPage: OnboardingInterestsScreen(),
            ),
          ),
        );
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    } else {
      final strings = AppLocalizations.of(context)!;
      SnackBarUtils.showTopSnackBar(
        context,
        strings.googleSignInFailed,
        isError: true,
      );
    }
  }

  // Extracted method for building social buttons
  Widget _buildSocialButtons(BuildContext context, AppLocalizations strings) {
    return Column(
      children: [
        CommonButton(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          height: 48.h,
          label: strings.loginWithStarnest,
          icon: SvgPicture.asset(ImageRes.svgs.appIcon),
          iconTextGap: 16.w,
          backgroundColor: ColorPalette.grey700,
          textStyle: TextStyles.s16.w600.generalSans
              .lhPercent(100)
              .cl(ColorPalette.grey400),
          borderRadius: 16,
          border: Border.all(color: ColorPalette.grey400, width: 2),
          onTap: () {
            context.pushNamed(AppRoutes.signinStarnest);
          },
        ),
        12.verticalSpace,
        // Google button — shows a spinner while sign-in is in progress
        CommonButton(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          height: 48.h,
          label: strings.continueWithGoogle,
          iconTextGap: 16.w,
          icon: _isGoogleLoading
              ? null
              : SvgPicture.asset(
                  ImageRes.svgs.googleIcon,
                  height: 24,
                  width: 24,
                ),
          isLoading: _isGoogleLoading,
          backgroundColor: ColorPalette.grey700,
          textStyle: TextStyles.s16.w600.generalSans
              .lhPercent(100)
              .cl(ColorPalette.grey400),
          borderRadius: 16,
          border: Border.all(color: ColorPalette.grey400, width: 2),
          onTap: _handleGoogleSignIn,
        ),
        12.verticalSpace,
        //Facebook Button
        CommonButton(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          height: 48.h,
          label: strings.continueWithFacebook,
          iconTextGap: 16.w,
          icon: _isFacebookLoading
              ? null
              : SvgPicture.asset(
                  ImageRes.svgs.facebookIcon,
                  height: 24,
                  width: 24,
                ),
          isLoading: _isFacebookLoading,
          backgroundColor: ColorPalette.grey700,
          textStyle: TextStyles.s16.w600.generalSans
              .lhPercent(100)
              .cl(ColorPalette.grey400),
          borderRadius: 16,
          border: Border.all(color: ColorPalette.grey400, width: 2),
          onTap: () {},
        ),
        12.verticalSpace,
        //Apple Button
        CommonButton(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          height: 48.h,
          label: strings.continueWithApple,
          iconTextGap: 16.w,
          icon: _isAppleLoading
              ? null
              : SvgPicture.asset(
                  ImageRes.svgs.appleIcon,
                  height: 24,
                  width: 24,
                ),
          isLoading: _isFacebookLoading,
          backgroundColor: ColorPalette.grey700,
          textStyle: TextStyles.s16.w600.generalSans
              .lhPercent(100)
              .cl(ColorPalette.grey400),
          borderRadius: 16,
          border: Border.all(color: ColorPalette.grey400, width: 2),
          onTap: () {},
        ),
      ],
    );
  }
}
