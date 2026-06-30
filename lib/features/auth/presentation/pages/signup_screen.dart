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
import 'package:starnest/features/auth/presentation/controllers/signup_controller.dart';
import 'package:starnest/features/auth/presentation/widget/term_condition_widget.dart';
import 'package:starnest/l10n/app_localizations.dart';
import 'package:starnest/app/routes/app_routes.dart';
import 'package:starnest/ui/atoms/common_button.dart';
import 'package:starnest/ui/atoms/common_divider.dart';
import 'package:starnest/ui/atoms/common_textfield.dart';
import 'package:starnest/ui/templates/common_scaffold.dart';

class SignUpScreen extends GetView<SignupController> {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

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
      showBack: true,
      defaultPadding: true,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.verticalSpace,
            Text(
              strings.signInBeforeReview,
              style: TextStyles.s24.w600.generalSans
                  .lhPercent(100)
                  .cl(ColorPalette.white300),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            CommonTextField(
              controller: controller.firstNameController,
              hint: 'First name',
            ),
            16.verticalSpace,
            CommonTextField(
              controller: controller.lastNameController,
              hint: 'Last name',
            ),
            16.verticalSpace,
            CommonTextField(
              controller: controller.emailController,
              hint: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            16.verticalSpace,
            CommonTextField(
              controller: controller.phoneController,
              hint: 'Phone number',
              keyboardType: TextInputType.phone,
            ),
            16.verticalSpace,
            CommonTextField.password(
              controller: controller.passwordController,
              hint: 'Password',
            ),
            32.verticalSpace,
            _buildCreateAccountButton(context, strings),
            12.verticalSpace,
            CommonDivider(
              text: strings.orDivider,
              color: ColorPalette.white400,
            ),
            12.verticalSpace,
            _buildSignInButton(context, strings),
            16.verticalSpace,
            TermsAndCondition(strings: strings),
            const Spacer(),
            SvgPicture.asset(ImageRes.svgs.appTitleLogo),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton(
    BuildContext context,
    AppLocalizations strings,
  ) {
    return Obx(
      () => CommonButton(
        padding: 12.paddingV,
        height: 48.h,
        label: strings.createAccount,
        backgroundColor: ColorPalette.white300,
        textStyle: TextStyles.s16.w600.generalSans
            .lhPercent(100)
            .cl(ColorPalette.grey800),
        isLoading: controller.isLoading.value,
        // onTap: controller.isButtonEnabled.value && !controller.isLoading.value
        //     ? () async {
        //         if (_formKey.currentState!.validate()) {
        //           await controller.registerUser();
        //           final err = controller.errorMessage.value;
        //           if (err != null && context.mounted) {
        //             SnackBarUtils.showTopSnackBar(context, err, isError: true);
        //           }
        //         }
        //       }
        //     : null,
        onTap: () => NavigationService.instance.offAll(AppRoutes.userInterest),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context, AppLocalizations strings) {
    return CommonButton(
      padding: 12.paddingV,
      height: 48.h,
      label: strings.signInNow,
      backgroundColor: ColorPalette.transparent,
      border: Border.all(color: ColorPalette.white300, width: 2),
      textStyle: TextStyles.s16.w600.generalSans
          .lhPercent(100)
          .cl(ColorPalette.white300),
      onTap: () => NavigationService.instance.off(AppRoutes.signinStarnest),
    );
  }
}
