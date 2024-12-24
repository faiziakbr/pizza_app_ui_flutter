import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/models/Tuple.dart';
import 'package:pizza_app_ui_flutter/models/menu_model.dart';
import 'package:pizza_app_ui_flutter/models/order_model.dart';
import 'package:pizza_app_ui_flutter/models/topping_model.dart';
import 'package:pizza_app_ui_flutter/modules/cart/cart_controller.dart';

class SelectionController extends GetxController with StateMixin<PizzaDetail> {
  final _data = Get.arguments;
  late Menu menuArg;
  late MenuItem menuItemArg;

  var cartController = Get.find<CartController>();

  List<PizzaModel> pizzas = [];
  late OrderItemModel boxModel;
  var pizzaCount = 0;

  @override
  void onInit() {
    menuArg = _data["menu"] as Menu;
    menuItemArg = _data["item"] as MenuItem;

    change(null, status: RxStatus.empty());
    super.onInit();
  }

  @override
  void onReady() {
    _loadJsonFromAssets("assets/details.json").then((value) {
      var data = PizzaDetail.fromJson(value);

      if (menuArg.category == "regular_flavors") {
        pizzaCount = 1;

        var pizzaModel = PizzaModel();
        pizzaModel.name = menuItemArg.name;
        pizzaModel.image = menuItemArg.image;
        pizzaModel.sizePrice = data.sizes[0].price;
        pizzaModel.maxToppings = data.toppings.vegetarian.length +
            data.toppings.nonVegetarian.length;
        pizzaModel.size = data.sizes[0].name;
        pizzas.add(pizzaModel);
      } else if (menuArg.category == "promotional_items") {
        pizzaCount = menuItemArg.promo?.length ?? 0;
        if (menuItemArg.promo == null) {
          change(null, status: RxStatus.error("unable to load data!"));
          return;
        }
        boxModel = OrderItemModel();
        boxModel.required = menuItemArg.promo!.length;

        for (int i = 0; i < menuItemArg.promo!.length; i++) {
          var promo = menuItemArg.promo![i];
          var pizzaModel = PizzaModel();
          pizzaModel.size = promo.size;
          var sizeModel =
              data.sizes.firstWhereOrNull((value) => value.name == promo.size);
          pizzaModel.sizePrice = sizeModel?.price;
          pizzaModel.maxToppings = promo.toppingsIncluded;
          pizzaModel.image = menuItemArg.image;

          pizzas.add(pizzaModel);
        }
      }

      change(data, status: RxStatus.success());
    }).catchError((error) {
      change(null, status: RxStatus.error("unable to load data!"));
    });
    super.onReady();
  }

  Tuple validate() {
    for (var pizza in pizzas) {
      if (pizza.name == null) {
        return Tuple(false, "Select one flavor");
      }

      if (menuArg.category == "promotional_items") {
        if (!((pizza.vegToppings.length + pizza.nonBegToppings.length) ==
            pizza.maxToppings)) {
          return Tuple(false, "Select ${pizza.maxToppings} toppings only!");
        }
      }
    }
    return Tuple(true, "All good");
  }

  void addToCart() {
    if (menuArg.category == "regular_flavors") {
      var totalPrice = 0.0;
      for (var pizza in pizzas) {
        totalPrice += pizza.sizePrice!;
        for (var toppingModel in pizza.vegToppings) {
          totalPrice += toppingModel.price;
        }
        for (var toppingModel in pizza.nonBegToppings) {
          totalPrice += toppingModel.price;
        }
      }

      var orderItem = OrderItemModel();
      orderItem.items = pizzas;
      orderItem.price = totalPrice;
      orderItem.actualPrice = totalPrice;
      orderItem.isPromoPrice = false;
      orderItem.image = pizzas[0].image;

      cartController.addItems(orderItem);
    } else if (menuArg.category == "promotional_items") {
      var totalPrice = 0.0;
      for (var pizza in pizzas) {
        totalPrice += pizza.sizePrice!;
        for (var toppingModel in pizza.vegToppings) {
          totalPrice += toppingModel.price;
        }
        for (var toppingModel in pizza.nonBegToppings) {
          totalPrice += toppingModel.price;
        }
      }

      var orderItem = OrderItemModel();
      orderItem.items = pizzas;
      orderItem.actualPrice = totalPrice;
      orderItem.isPromoPrice = true;
      orderItem.image = pizzas[0].image;
      if (menuItemArg.price != null) {
        orderItem.price = menuItemArg.price;
      } else if (menuItemArg.discount != null) {
        orderItem.price = totalPrice * (menuItemArg.discount! / 100);
      }

      cartController.addItems(orderItem);
    }
  }

  //private functions
  Future<Map<String, dynamic>> _loadJsonFromAssets(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    return jsonDecode(jsonString);
  }
}
