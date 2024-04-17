import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:machine_test_nectar/app/modules/create/controllers/create_controller.dart';
import 'package:machine_test_nectar/app/modules/create/widgets/file_selector_chip.dart';
import 'package:machine_test_nectar/app/widgets/app_textfield.dart';

class FilePickerView extends GetView<CreateController> {
  const FilePickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        showFileSelectorBottomSheet();
      },
      child: Stack(
        alignment: Alignment.centerLeft,
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
                child: Text(
                  'Pick a file',
                  style: TextStyle(
                    color: controller.showPadding.value ? Colors.red : null,
                  ),
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

  /// to show options for selcting a file
  void showFileSelectorBottomSheet() {
    Get.bottomSheet(
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 25.0,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pick file using',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25.0),
            Align(
              alignment: Alignment.center,
              child: Wrap(
                spacing: 25,
                runSpacing: 25,
                children:
                    List.generate(controller.fileSelectorList.length, (index) {
                  return FileSelectorChip(
                    fileSelectorModel: controller.fileSelectorList[index],
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
