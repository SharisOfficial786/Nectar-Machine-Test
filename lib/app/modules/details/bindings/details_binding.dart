import 'package:get/get.dart';
import 'package:machine_test_nectar/app/modules/details/controllers/details_controller.dart';

class DetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsController>(
      () => DetailsController(),
    );
  }
}
