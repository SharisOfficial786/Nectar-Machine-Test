import 'package:get/get.dart';
import 'package:machine_test_nectar/app/routes/app_pages.dart';

class SplashController extends GetxController {
  String text = 'Welcome...';

  @override
  void onInit() {
    initialteSplash();
    super.onInit();
  }

  /// initiate splash
  Future<void> initialteSplash() async {
    Future.delayed(const Duration(seconds: 1), () {
      Get.offAllNamed(Routes.home);
    });
  }
}
