import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:starnest/core/constants/color_palette.dart';
import 'package:starnest/core/extensions/text_style_ext.dart';
import 'package:starnest/core/service/navigator_service.dart';
import 'package:starnest/features/auth/presentation/controllers/user_interest_controller.dart';
import 'package:starnest/features/auth/presentation/widget/interest_chip.dart';
import 'package:starnest/l10n/app_localizations.dart';
import 'package:starnest/ui/molecules/double_button.dart';
import 'package:starnest/ui/templates/common_scaffold.dart';
import 'package:starnest/core/utils/tab_helper.dart';
import 'package:starnest/app/routes/app_routes.dart';
import 'package:starnest/core/utils/snackbar_utils.dart';

class UserInterestScreen extends GetView<UserInterestController> {
  const UserInterestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return CommonScaffold(
      defaultPadding: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          40.verticalSpace,
          Text(
            strings.letsGetStarted,
            style: TextStyles.s24.w600.generalSans
                .lhPercent(100)
                .cl(ColorPalette.white100),
          ),
          12.verticalSpace,
          Text(
            strings.tellUsWhatYouAreInto,
            style: TextStyles.s12.w400.generalSans
                .lhPercent(120)
                .cl(ColorPalette.white100),
          ),
          48.verticalSpace,
          Text(
            strings.chooseYourInterests,
            style: TextStyles.s18.w500.generalSans
                .lhPercent(100)
                .cl(ColorPalette.white300),
          ),
          16.verticalSpace,
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: TabUtils.getAll().map((tab) {
              return Obx(() {
                final bool isSelected = controller.selectedMainInterests
                    .contains(tab.name);
                return GestureDetector(
                  onTap: () => controller.toggleMainInterest(tab.name),
                  child: InterestChip(
                    label: tab.name,
                    color: tab.color,
                    isSelected: isSelected,
                  ),
                );
              });
            }).toList(),
          ),
          Spacer(),
          DoubleButton(
            textLeft: strings.skip,
            textRight: strings.continueText,
            onTapLeft: () => NavigationService.instance.offAll(AppRoutes.home),
            onTapRight: () {
              if (controller.selectedMainInterests.isNotEmpty) {
                controller.startSubInterestFlow();
              } else {
                SnackBarUtils.showTopSnackBar(
                  context,
                  strings.pleaseSelectAtleast1Interest,
                  isError: true,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
