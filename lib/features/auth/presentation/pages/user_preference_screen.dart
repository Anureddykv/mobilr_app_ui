import 'package:flutter/material.dart' hide Tab;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:starnest/core/constants/color_palette.dart';
import 'package:starnest/core/extensions/text_style_ext.dart';
import 'package:starnest/features/auth/presentation/controllers/user_interest_controller.dart';
import 'package:starnest/features/auth/presentation/widget/preference_section.dart';
import 'package:starnest/ui/molecules/double_button.dart';
import 'package:starnest/ui/templates/common_scaffold.dart';
import 'package:starnest/core/utils/tab_helper.dart';
import 'package:starnest/l10n/app_localizations.dart';

class UserPreferenceScreen extends GetView<UserInterestController> {
  const UserPreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return CommonScaffold(
      defaultPadding: true,
      body: Obx(() {
        final currentInterest = controller.activeSubInterestScreen.value;
        if (currentInterest.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final interestData = controller.getSubInterestData(currentInterest);
        final String title = interestData.title;
        final String description = interestData.description;

        Color color = Colors.grey;
        for (var tab in Tab.values) {
          if (TabUtils.get(tab).name == currentInterest) {
            color = TabUtils.get(tab).color;
            break;
          }
        }

        final Map<String, List<String>> sections = interestData.sections;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    40.verticalSpace,
                    Text(
                      title,
                      style: TextStyles.s24.w600.generalSans
                          .lhPercent(100)
                          .cl(color),
                    ),
                    12.verticalSpace,
                    Text(
                      description,
                      style: TextStyles.s12.w400.generalSans
                          .lhPercent(120)
                          .cl(ColorPalette.white100),
                    ),
                    48.verticalSpace,
                    ...sections.entries.map((entry) {
                      return PreferenceSection(
                        controller: controller,
                        mainInterest: currentInterest,
                        title: entry.key,
                        items: entry.value,
                        chipColor: color,
                        selectAllText: strings.selectAll,
                      );
                    }),
                  ],
                ),
              ),
            ),
            16.verticalSpace,
            DoubleButton(
              textLeft: strings.skip,
              textRight: strings.continueText,
              onTapLeft: () => controller.navigateToNextInterestOrFinish(),
              onTapRight: () => controller.navigateToNextInterestOrFinish(),
            ),
          ],
        );
      }),
    );
  }
}
