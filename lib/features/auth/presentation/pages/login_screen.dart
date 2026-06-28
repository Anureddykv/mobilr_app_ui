import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:starnest/core/constants/app_images.dart';
import 'package:starnest/core/constants/color_palette.dart';
import 'package:starnest/core/extensions/num_ext.dart';
import 'package:starnest/core/extensions/text_style_ext.dart';
import 'package:starnest/core/tracking/starnest_tracker.dart';
import 'package:starnest/core/service/api_service.dart';
import 'package:starnest/core/utils/snackbar_utils.dart';
import 'package:starnest/l10n/app_localizations.dart';
import 'package:starnest/routes/app_routes.dart';
import 'package:starnest/ui/atoms/common_button.dart';
import 'package:starnest/ui/atoms/common_textfield.dart';
import 'package:starnest/ui/templates/common_scaffold.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
            controller: _usernameController,
            hint: "Username / Email",
          ),
          16.verticalSpace,
          CommonTextField.password(
            controller: _passwordController,
            hint: "Password",
          ),
          const SizedBox(height: 40),
          _buildLoginButton(strings),
          const Spacer(),
          SvgPicture.asset(ImageRes.svgs.appTitleLogo),
          16.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildLoginButton(AppLocalizations strings) {
    return CommonButton(
      padding: 12.paddingV,
      height: 48.h,
      label: strings.login,
      backgroundColor: ColorPalette.white300,
      textStyle: TextStyles.s16.w600.generalSans
          .lhPercent(100)
          .cl(ColorPalette.grey800),
      onTap: _isLoading
          ? null
          : () async {
              String errorMessage = "";
              if (_usernameController.text.isEmpty &&
                  _passwordController.text.isEmpty) {
                errorMessage = "Please enter Username and Password";
              } else if (_usernameController.text.isEmpty) {
                errorMessage = "Please enter Username / Email";
              } else if (_passwordController.text.isEmpty) {
                errorMessage = "Please enter Password";
              }

              if (errorMessage.isEmpty) {
                setState(() {
                  _isLoading = true;
                });
                final api = ApiService();
                final result = await api.login(
                  _usernameController.text,
                  _passwordController.text,
                );
                setState(() {
                  _isLoading = false;
                });

                if (result != null) {
                  final userId = result['userId'] ?? '';
                  final sessionId = result['sessionId'] ?? '';
                  final user =
                      result['raw']?['user'] as Map<String, dynamic>? ?? {};
                  StarNestTracker.instance.sessionStart(
                    token: result['token'] ?? '',
                    userId: userId,
                    sessionId: sessionId,
                    firstName: user['firstName']?.toString(),
                    lastName: user['lastName']?.toString(),
                    email: user['email']?.toString(),
                    avatarUrl:
                        user['profileImage']?.toString() ??
                        user['avatarUrl']?.toString(),
                  );
                  Get.offAllNamed(AppRoutes.home);
                } else {
                  SnackBarUtils.showTopSnackBar(
                    context,
                    "Invalid username or password",
                    isError: true,
                  );
                }
              } else {
                SnackBarUtils.showTopSnackBar(
                  context,
                  errorMessage,
                  isError: true,
                );
              }
            },
    );
  }
}
