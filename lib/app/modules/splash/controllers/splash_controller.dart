import 'package:get/get.dart';
import 'package:machine_test_nectar/app/routes/app_pages.dart';

class SplashController extends GetxController {
  String text = 'An app to manage your files...';

  @override
  void onInit() {
    initialteSplash();
    super.onInit();
  }

  /// initiate splash
  Future<void> initialteSplash() async {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(Routes.home);
    });
  }
}
