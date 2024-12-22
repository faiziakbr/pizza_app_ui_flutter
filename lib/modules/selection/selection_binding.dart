import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/modules/selection/selection_controller.dart';

class SelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.replace(SelectionController());
  }
}
