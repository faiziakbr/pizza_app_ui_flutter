import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/models/menu_model.dart';
import 'package:pizza_app_ui_flutter/models/topping_model.dart';
import 'package:pizza_app_ui_flutter/modules/cart/cart_controller.dart';

class SelectionController extends GetxController with StateMixin<PizzaDetail> {
  final _data = Get.arguments;
  late Menu menu;
  late MenuItem menuItem;

  var cartController = Get.find<CartController>();

  //Vegetarian toppings selection
  List<ToppingModel> selectedVegToppings = [];
  RxList<bool> vegSelected = RxList<bool>();

  //non-Vegetarian toppings selection
  List<ToppingModel> selectedNonVegToppings = [];
  RxList<bool> nonVegSelected = RxList<bool>();

  var sizePrice = 0.0;
  var itemPrice = 0.0.obs;

  @override
  void onInit() {
    menu = _data["menu"] as Menu;
    menuItem = _data["item"] as MenuItem;

    change(null, status: RxStatus.empty());

    super.onInit();
  }

  @override
  void onReady() {
    _loadJsonFromAssets("assets/details.json").then((value) {
      var data = PizzaDetail.fromJson(value);
      // data.toppings.vegetarian
      vegSelected = RxList<bool>.filled(data.toppings.vegetarian.length, false);
      nonVegSelected =
          RxList<bool>.filled(data.toppings.nonVegetarian.length, false);
      change(data, status: RxStatus.success());
    }).catchError((error) {
      change(null, status: RxStatus.error("unable to load data!"));
    });
    super.onReady();
  }

  void addPrice(double amount) {
    itemPrice.value += amount;
  }

  void removePrice(double amount) {
    itemPrice.value -= amount;
  }

  //private functions
  Future<Map<String, dynamic>> _loadJsonFromAssets(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    return jsonDecode(jsonString);
  }
}
