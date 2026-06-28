import 'package:get/get.dart';

class NavigationService {
  NavigationService._();

  static final instance = NavigationService._();

  Future<T?>? to<T>(String route, {dynamic arguments}) {
    return Get.toNamed<T>(route, arguments: arguments);
  }

  Future<T?>? off<T>(String route, {dynamic arguments}) {
    return Get.offNamed<T>(route, arguments: arguments);
  }

  Future<T?>? offAll<T>(String route, {dynamic arguments}) {
    return Get.offAllNamed<T>(route, arguments: arguments);
  }

  void back<T>([T? result]) {
    Get.back(result: result);
  }
}
