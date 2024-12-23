import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension CustomSnackbar on GetInterface {
  void customSnackbar(String title, String message, {bool error = false}) {
    Get.snackbar(title, message,
        backgroundColor: error ? Colors.red : Colors.yellow,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true);
  }
}
