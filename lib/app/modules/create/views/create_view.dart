import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:machine_test_nectar/app/modules/create/controllers/create_controller.dart';
import 'package:machine_test_nectar/app/modules/create/widgets/file_picked_view.dart';
import 'package:machine_test_nectar/app/modules/create/widgets/file_picker_view.dart';
import 'package:machine_test_nectar/app/widgets/app_textfield.dart';

class CreateView extends GetView<CreateController> {
  const CreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.documentData != null ? 'Update' : 'Create'),
        centerTitle: true,
        backgroundColor: Colors.purple.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              AppTextField(
                controller: controller.titleController,
                labelText: 'Title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  } else if (!controller.isAlphabet(value)) {
                    return 'Please enter alphabets only';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              AppTextField(
                controller: controller.descriptionController,
                labelText: 'Description',
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15.0),
              Obx(() {
                return controller.file.value != null
                    ? const FilePickedView()
                    : const FilePickerView();
              }),
              const SizedBox(height: 15.0),
              IgnorePointer(
                child: AppTextField(
                  controller: controller.fileTypeController,
                  labelText: 'Document type',
                ),
              ),
              const SizedBox(height: 15.0),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  controller.pickDate(context);
                },
                child: IgnorePointer(
                  child: AppTextField(
                    controller: controller.expiryDateController,
                    labelText: 'Expiry date',
                  ),
                ),
              ),
              const SizedBox(height: 35.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (controller.documentData != null) ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showDeleteConfirmation();
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30.0),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          if (controller.documentData == null) {
                            controller.insertDocumentToDb();
                          } else {
                            controller.updateDocumentToDb();
                          }
                        }
                      },
                      child: Text(
                        controller.documentData != null ? 'Save' : 'Add',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
              'Delete this item?',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () {
                controller.deleteDocumentFromDb();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(Get.width, 45.0),
              ),
              child: const Text(
                'Delete',
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
