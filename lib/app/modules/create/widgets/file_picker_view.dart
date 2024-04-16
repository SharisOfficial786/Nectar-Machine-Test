import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:machine_test_nectar/app/modules/create/controllers/create_controller.dart';
import 'package:machine_test_nectar/app/widgets/app_textfield.dart';

class FilePickerView extends GetView<CreateController> {
  const FilePickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        await controller.selectFile();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AppTextField(
            enabled: false,
            controller: TextEditingController(),
            labelText: '',
            validator: (_) {
              if (controller.file.value == null) {
                controller.showPadding.value = true;
                return 'Please select a file';
              }
              return null;
            },
          ),
          Positioned(
            child: Obx(() {
              return Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  bottom: controller.showPadding.value ? 20.0 : 0.0,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/file.png',
                      height: 24.0,
                      width: 24.0,
                      color: controller.showPadding.value ? Colors.red : null,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      'Pick a file',
                      style: TextStyle(
                        color: controller.showPadding.value ? Colors.red : null,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          Positioned(
            right: 16,
            child: Obx(() {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: controller.showPadding.value ? 20.0 : 0.0,
                ),
                child: Image.asset(
                  'assets/images/right.png',
                  height: 24.0,
                  width: 24.0,
                  color: controller.showPadding.value ? Colors.red : null,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
