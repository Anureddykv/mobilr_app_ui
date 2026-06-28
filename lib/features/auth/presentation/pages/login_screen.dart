import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:starnest/core/constants/app_images.dart';
import 'package:starnest/core/constants/color_palette.dart';
import 'package:starnest/core/extensions/num_ext.dart';
import 'package:starnest/core/extensions/text_style_ext.dart';
import 'package:starnest/core/utils/snackbar_utils.dart';
import 'package:starnest/features/auth/presentation/controllers/login_controller.dart';
import 'package:starnest/l10n/app_localizations.dart';
import 'package:starnest/ui/atoms/common_button.dart';
import 'package:starnest/ui/atoms/common_textfield.dart';
import 'package:starnest/ui/templates/common_scaffold.dart';

class SignInScreen extends GetView<LoginController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return CommonScaffold(
      showBack: true,
      defaultPadding: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          20.verticalSpace,
          Text(
            strings.loginWithStarnest,
            style: TextStyles.s24.w600.generalSans
                .lhPercent(100)
                .cl(ColorPalette.white300),
            textAlign: TextAlign.center,
          ),
          24.verticalSpace,
          CommonTextField(
            controller: controller.emailController,
            hint: 'Username / Email',
          ),
          16.verticalSpace,
          CommonTextField.password(
            controller: controller.passwordController,
            hint: 'Password',
          ),
          const SizedBox(height: 40),
          _buildLoginButton(context, strings),
          const Spacer(),
          SvgPicture.asset(ImageRes.svgs.appTitleLogo),
          16.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, AppLocalizations strings) {
    return Obx(
      () => CommonButton(
        padding: 12.paddingV,
        height: 48.h,
        label: strings.login,
        backgroundColor: ColorPalette.white300,
        textStyle: TextStyles.s16.w600.generalSans
            .lhPercent(100)
            .cl(ColorPalette.grey800),
        isLoading: controller.isLoading.value,
        onTap: controller.isLoading.value
            ? null
            : () async {
                await controller.login();
                final err = controller.errorMessage.value;
                if (err != null && context.mounted) {
                  SnackBarUtils.showTopSnackBar(context, err, isError: true);
                }
              },
      ),
    );
  }
}
