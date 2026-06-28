import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:starnest/core/constants/app_images.dart';
import 'package:starnest/core/constants/color_palette.dart';
import 'package:starnest/core/extensions/num_ext.dart';
import 'package:starnest/core/extensions/text_style_ext.dart';
import 'package:starnest/core/service/navigator_service.dart';
import 'package:starnest/core/utils/snackbar_utils.dart';
import 'package:starnest/features/auth/presentation/controllers/login_option_controller.dart';
import 'package:starnest/features/auth/presentation/widget/term_condition_widget.dart';
import 'package:starnest/l10n/app_localizations.dart';
import 'package:starnest/app/routes/app_routes.dart';
import 'package:starnest/ui/atoms/common_button.dart';
import 'package:starnest/ui/atoms/common_divider.dart';
import 'package:starnest/ui/templates/common_scaffold.dart';

class LoginOptionScreen extends GetView<LoginOptionController> {
  const LoginOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    // Show error snackbar reactively whenever errorMessage changes.
    ever(controller.errorMessage, (msg) {
      if (msg != null && msg.isNotEmpty && context.mounted) {
        SnackBarUtils.showTopSnackBar(context, msg, isError: true);
      }
    });

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
          _buildSocialButtons(context, strings),
          16.verticalSpace,
          CommonDivider(text: strings.orDivider, color: ColorPalette.white400),
          16.verticalSpace,
          CommonButton(
            padding: 12.paddingV,
            height: 48.h,
            label: strings.createAccount,
            backgroundColor: ColorPalette.white300,
            textStyle: TextStyles.s16.w600.generalSans
                .lhPercent(100)
                .cl(ColorPalette.grey800),
            onTap: () => NavigationService.instance.to(AppRoutes.signup),
          ),
          16.verticalSpace,
          TermsAndCondition(strings: strings),
          const Spacer(),
          SvgPicture.asset(ImageRes.svgs.appTitleLogo),
          16.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildSocialButtons(BuildContext context, AppLocalizations strings) {
    return Obx(
      () => Column(
        children: [
          // StarNest Email Login
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
            onTap: () =>
                NavigationService.instance.to(AppRoutes.signinStarnest),
          ),
          12.verticalSpace,

          // Google
          CommonButton(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            height: 48.h,
            label: strings.continueWithGoogle,
            iconTextGap: 16.w,
            icon: controller.isGoogleLoading.value
                ? null
                : SvgPicture.asset(
                    ImageRes.svgs.googleIcon,
                    height: 24,
                    width: 24,
                  ),
            isLoading: controller.isGoogleLoading.value,
            backgroundColor: ColorPalette.grey700,
            textStyle: TextStyles.s16.w600.generalSans
                .lhPercent(100)
                .cl(ColorPalette.grey400),
            borderRadius: 16,
            border: Border.all(color: ColorPalette.grey400, width: 2),
            onTap: controller.signInWithGoogle,
          ),
          12.verticalSpace,

          // Facebook (placeholder)
          CommonButton(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            height: 48.h,
            label: strings.continueWithFacebook,
            iconTextGap: 16.w,
            icon: SvgPicture.asset(
              ImageRes.svgs.facebookIcon,
              height: 24,
              width: 24,
            ),
            backgroundColor: ColorPalette.grey700,
            textStyle: TextStyles.s16.w600.generalSans
                .lhPercent(100)
                .cl(ColorPalette.grey400),
            borderRadius: 16,
            border: Border.all(color: ColorPalette.grey400, width: 2),
            onTap: () {},
          ),
          12.verticalSpace,

          // Apple (placeholder)
          CommonButton(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            height: 48.h,
            label: strings.continueWithApple,
            iconTextGap: 16.w,
            icon: SvgPicture.asset(
              ImageRes.svgs.appleIcon,
              height: 24,
              width: 24,
            ),
            backgroundColor: ColorPalette.grey700,
            textStyle: TextStyles.s16.w600.generalSans
                .lhPercent(100)
                .cl(ColorPalette.grey400),
            borderRadius: 16,
            border: Border.all(color: ColorPalette.grey400, width: 2),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
