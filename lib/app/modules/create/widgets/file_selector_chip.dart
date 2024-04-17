import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:machine_test_nectar/app/modules/create/models/file_selector_model.dart';

class FileSelectorChip extends StatelessWidget {
  const FileSelectorChip({super.key, required this.fileSelectorModel});

  final FileSelectorModel fileSelectorModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => fileSelectorModel.onTap(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor:
                Get.theme.floatingActionButtonTheme.backgroundColor,
            child: Image.asset(
              'assets/images/${fileSelectorModel.icon}.png',
              height: 24.0,
              width: 24.0,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(fileSelectorModel.title),
        ],
      ),
    );
  }
}
