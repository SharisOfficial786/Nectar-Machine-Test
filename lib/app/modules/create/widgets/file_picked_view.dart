import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:machine_test_nectar/app/modules/create/controllers/create_controller.dart';

class FilePickedView extends GetView<CreateController> {
  const FilePickedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(20.0),
                  onTap: () => controller.goToDetails(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade600,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                controller.filePath ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            if (!controller.showLinearprogressIndicator.value ||
                                controller.documentData != null) ...[
                              const SizedBox(width: 3.0),
                              const Icon(
                                Icons.arrow_right_alt_sharp,
                                color: Colors.white,
                              ),
                            ],
                          ],
                        ),
                        if (controller.showLinearprogressIndicator.value &&
                            controller.documentData == null) ...[
                          const SizedBox(height: 3.0),
                          SizedBox(
                            height: 3,
                            child: TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: const Duration(seconds: 1),
                              onEnd: () {
                                controller.showLinearprogressIndicator.value =
                                    false;
                              },
                              builder: (BuildContext context, double value,
                                  Widget? child) {
                                return LinearProgressIndicator(
                                  backgroundColor: const Color(0xFFCDD4DB),
                                  color: const Color(0xFF697D92),
                                  borderRadius: BorderRadius.circular(
                                    40.0,
                                  ),
                                  value: value,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF697D92),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          Visibility(
            visible: !controller.showLinearprogressIndicator.value ||
                controller.documentData != null,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => showDeleteConfirmation(),
              child: Image.asset(
                'assets/images/trash.png',
                height: 24.0,
                width: 24.0,
                color: Colors.red,
              ),
            ),
          ),
        ],
      );
    });
  }

  void showDeleteConfirmation() {
    Get.bottomSheet(
      Container(
        width: Get.width,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Remove this file?',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () {
                controller.removeFile();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(Get.width, 45.0),
              ),
              child: const Text(
                'Remove',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(Get.width, 45.0),
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
