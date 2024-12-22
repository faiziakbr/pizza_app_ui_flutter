import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/models/menu_model.dart';


class CartController extends GetxController {

  // var menuItems = Rxn<MenuItem>();
  var menuItems = <MenuItem>[].obs;

  void addItems(MenuItem menuItem) {
    menuItems.add(menuItem);
  }
}
