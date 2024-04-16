import 'package:flutter/material.dart' show EdgeInsets;
import 'package:get/get.dart';

class AppSnackbar {
  static showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.only(
        bottom: 8.0,
        left: 16.0,
        right: 16.0,
      ),
    );
  }
}
