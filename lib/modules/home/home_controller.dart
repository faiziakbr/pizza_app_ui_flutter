import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/models/menu_model.dart';
import 'package:pizza_app_ui_flutter/models/topping_model.dart';
import 'package:pizza_app_ui_flutter/modules/cart/cart_controller.dart';

class HomeController extends GetxController with StateMixin<MenuData> {

  var cartController = Get.find<CartController>();
  var pizzaDetail = Rxn<PizzaDetail>();

  @override
  void onInit() {
    change(null, status: RxStatus.empty());

    super.onInit();
  }

  @override
  void onReady() {
    _loadJsonFromAssets("assets/menu.json").then((value) {
      MenuData data = MenuData.fromJson(value);
      change(data, status: RxStatus.success());
    }).catchError((error) {
      change(null, status: RxStatus.error("unable to load data!"));
    });

    _loadJsonFromAssets("assets/details.json").then((value) {
      pizzaDetail.value = PizzaDetail.fromJson(value);
    }).catchError((error) {

    });
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  //public functions

  void addItem(MenuItem? item) {
    print("ADD ITEM: ${item}");
    if (item == null) return;
    // menu.items.add(item);
    cartController.addItems(item);

    print("GOT MENU ITEM: ${cartController.menuItems.value}");
  }

  // returns true to allow user to select only toppings but not size of that particular item
  // int isPromotional(Menu menu, MenuItem item) {
  //   if(menu.category == "promotional_items") {
  //
  //     return ;
  //   }
  //   return 0;
  // }

  //private functions
  Future<Map<String, dynamic>> _loadJsonFromAssets(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    return jsonDecode(jsonString);
  }
}
