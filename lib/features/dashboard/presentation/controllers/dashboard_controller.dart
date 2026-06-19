import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxInt selectedBottomNavIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedBottomNavIndex.value = index;
  }
}
