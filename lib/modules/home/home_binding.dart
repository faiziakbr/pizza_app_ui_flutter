import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/modules/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.replace(HomeController());
  }
}
