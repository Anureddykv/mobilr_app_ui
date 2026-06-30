import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:starnest/app/routes/app_routes.dart';
import 'package:starnest/core/constants/color_palette.dart';
import 'package:starnest/core/extensions/num_ext.dart';
import 'package:starnest/core/extensions/text_style_ext.dart';
import 'package:starnest/core/service/navigator_service.dart';
import 'package:starnest/features/splash/presentation/controllers/onboarding_controller.dart';
import 'package:starnest/ui/templates/common_scaffold.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      defaultPadding: false,
      body: Obx(() {
        final slides = controller.slides.toList();

        return Column(
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is OverscrollNotification &&
                      controller.currentIndex.value ==
                          controller.slides.length - 1 &&
                      notification.overscroll > 0) {
                    controller.viewedOnboarding();
                    NavigationService.instance.off(AppRoutes.loginOption);
                  }
                  return false;
                },
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: slides.length,
                  onPageChanged: controller.onPageChanged,
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SvgPicture.asset(
                          slide.image,
                          height: 450.h,
                          width: 375.w,
                        ),
                        40.verticalSpace,
                        Padding(
                          padding: 10.paddingH,
                          child: Text(
                            slide.text,
                            textAlign: TextAlign.center,
                            style: TextStyles.s20.w600.generalSans
                                .lhPercent(100)
                                .cl(ColorPalette.white300),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            _buildIndicator(),
            20.verticalSpace,
          ],
        );
      }),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => Container(
          margin: 4.paddingH,
          width: controller.currentIndex.value == index ? 14 : 12,
          height: controller.currentIndex.value == index ? 14 : 12,
          decoration: BoxDecoration(
            color: ColorPalette.grey300,
            border: controller.currentIndex.value == index
                ? Border.all(color: ColorPalette.white300, width: 2.0)
                : null,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
