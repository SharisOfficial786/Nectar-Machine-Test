import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:machine_test_nectar/app/modules/create/controllers/create_controller.dart';
import 'package:machine_test_nectar/app/widgets/app_textfield.dart';

class FilePickedView extends GetView<CreateController> {
  const FilePickedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          Flexible(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                controller.removeFile();
              },
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Column(
                    children: [
                      IgnorePointer(
                        child: AppTextField(
                          controller: TextEditingController(
                            text: controller.filePath,
                          ),
                          labelText: 'Selected file',
                        ),
                      ),
                      if (controller.showLinearprogressIndicator.value &&
                          controller.documentData == null) ...[
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
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
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF697D92),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                  Visibility(
                    visible: !controller.showLinearprogressIndicator.value ||
                        controller.documentData != null,
                    child: Positioned(
                      right: 16,
                      child: Image.asset(
                        'assets/images/trash.png',
                        height: 24.0,
                        width: 24.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (controller.documentData != null) ...[
            IconButton(
              onPressed: () {
                controller.goToDetails();
              },
              icon: Image.asset(
                'assets/images/view.png',
                height: 24.0,
                width: 24.0,
              ),
            ),
          ],
        ],
      );
    });
  }
}
