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
              const SizedBox(height: 15.0),
              PopupMenuButton<String>(
                position: PopupMenuPosition.under,
                constraints: BoxConstraints(minWidth: Get.width - 32),
                itemBuilder: (BuildContext context) {
                  return controller.fileFormats.map((String e) {
                    return PopupMenuItem<String>(
                      value: e,
                      child: Text(e),
                    );
                  }).toList();
                },
                onSelected: (value) {
                  controller.selectDocTypeFromDropdown(value);
                },
                child: IgnorePointer(
                  child: AppTextField(
                    controller: controller.fileTypeController,
                    labelText: 'Document type',
                  ),
                ),
              ),
              const SizedBox(height: 35.0),
              ElevatedButton(
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    if (controller.documentData == null) {
                      controller.insertDocumnetToDb();
                    } else {
                      controller.updateDocumnetToDb(
                        controller.documentData!.id!,
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 43.0),
                ),
                child: Text(controller.documentData != null ? 'Save' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
