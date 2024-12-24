import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/modules/cart/cart_controller.dart';
import 'package:pizza_app_ui_flutter/theme/ThemeController.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() async {
    // Get.put(ThemeController()); //TODO: use this if needed
    Get.put(CartController());
  }
}