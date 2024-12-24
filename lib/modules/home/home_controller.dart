import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/models/menu_model.dart';
import 'package:pizza_app_ui_flutter/modules/cart/cart_controller.dart';

class HomeController extends GetxController with StateMixin<MenuData> {
  var cartController = Get.find<CartController>();

  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    super.onInit();
  }

  @override
  void onReady() {
    loadData();
    super.onReady();
  }

  void loadData() {
    _loadJsonFromAssets("assets/menu.json").then((value) {
      MenuData data = MenuData.fromJson(value);
      change(data, status: RxStatus.success());
    }).catchError((error) {
      change(null, status: RxStatus.error("unable to load data!"));
    });
  }

  //private functions
  Future<Map<String, dynamic>> _loadJsonFromAssets(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    return jsonDecode(jsonString);
  }
}
