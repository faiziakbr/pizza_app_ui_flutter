import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/models/menu_model.dart';
import 'package:pizza_app_ui_flutter/models/order_model.dart';
import 'package:pizza_app_ui_flutter/models/promo_model.dart';
import 'package:pizza_app_ui_flutter/models/size_model.dart';
import 'package:pizza_app_ui_flutter/models/topping_model.dart';
import 'package:pizza_app_ui_flutter/modules/cart/cart_controller.dart';

class SelectionController extends GetxController with StateMixin<PizzaDetail> {
  final _data = Get.arguments;
  late Menu menuArg;
  late MenuItem menuItemArg;

  // var boxes = BoxModel(items, 1);
  // var orderItems = OrderItemModel(boxes);

  var cartController = Get.find<CartController>();

  //Vegetarian toppings selection
  List<ToppingModel> selectedVegToppings = [];
  RxList<bool> vegSelected = RxList<bool>();

  //non-Vegetarian toppings selection
  List<ToppingModel> selectedNonVegToppings = [];
  RxList<bool> nonVegSelected = RxList<bool>();

  var sizePrice = 0.0;
  var itemPrice = 0.0.obs;

  List<PizzaModel> pizzas = [];
  late OrderItemModel boxModel;
  var pizzaCount = 0;

  @override
  void onInit() {
    menuArg = _data["menu"] as Menu;
    menuItemArg = _data["item"] as MenuItem;
    // print("Got Menu: ${menu.toString()} ||| ${menuItem.toString()}");

    // TODO TEST

    // var item1 = MenuItem(id: 1, name: "Peopp");
    // var item2 = MenuItem(id: 2, name: "supreme");
    //
    // var box1 = BoxModel([item1, item2], 2);
    //
    // var orderItem1 = OrderItemModel([box1]);
    //
    // var order = OrderModel();
    // order.orderItems.add(orderItem1);

    //TODO TEST END

    change(null, status: RxStatus.empty());
    super.onInit();
  }

  @override
  void onReady() {
    _loadJsonFromAssets("assets/details.json").then((value) {
      var data = PizzaDetail.fromJson(value);
      vegSelected = RxList<bool>.filled(data.toppings.vegetarian.length, false);
      nonVegSelected =
          RxList<bool>.filled(data.toppings.nonVegetarian.length, false);

      if (menuArg.category == "regular_flavors") {
        pizzaCount = 1;
        // completeMenuItem = menuItemArg;
        // menuItemArg.promo?.add(Promo(id: 1, toppingsIncluded: 1, size: 'Medium', image: 'assets/1.png'));

        var pizzaModel = PizzaModel();
        pizzaModel.name = menuItemArg.name;
        pizzaModel.image = menuItemArg.image;
        // pizzaModel.price = menuItemArg.price;
        pizzaModel.sizePrice = data.sizes[0].price;
        pizzaModel.maxToppings = data.toppings.vegetarian.length +
            data.toppings.nonVegetarian.length;
        pizzaModel.size = data.sizes[0].name;
        pizzas.add(pizzaModel);
      } else if (menuArg.category == "promotional_items") {
        pizzaCount = menuItemArg.promo?.length ?? 0;
        boxModel = OrderItemModel();
        boxModel.required = menuItemArg.promo!.length;

        // for (int i = 0; i < menuItemArg.pizzaCount!; i++) {
        for (int i = 0; i < menuItemArg.promo!.length; i++) {
          var promo = menuItemArg.promo![i];
          var pizzaModel = PizzaModel();
          pizzaModel.size = promo.size;
          var sizeModel = data.sizes.firstWhereOrNull( (value) => value.name == promo.size);
          pizzaModel.sizePrice = sizeModel?.price;
          pizzaModel.maxToppings = promo.toppingsIncluded;
          pizzaModel.image = menuItemArg.image;

          pizzas.add(pizzaModel);
        }
        // }
      }

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

  Tuple calculate() {
    for (var pizza in pizzas) {
      print("GOT PIZZA: ${pizza.toString()}");
      if (pizza.name == null) {
        return Tuple(false, "Select one flavor");
      }
      // print(" GOT INDOT: ${pizza.vegToppings.length + pizza.nonBegToppings.length} and ${pizza.maxToppings} and ${(pizza.vegToppings.length + pizza.nonBegToppings.length) > pizza.maxToppings} ");
      if (menuArg.category == "promotional_items") {
        if (!((pizza.vegToppings.length + pizza.nonBegToppings.length) ==
            pizza.maxToppings)) {
          return Tuple(false,
              "${pizza.name ?? ""} need to select at ${pizza
                  .maxToppings} toppings!");
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
      // print("GOT BOX MODEL: ${boxModel}");
      // var orderItem = OrderItemModel();
      // orderItem.boxes.add(boxModel);

      cartController.addItems(orderItem);
    }

    if (menuArg.category == "promotional_items") {
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
      print("GOT BOX MODEL: ${orderItem}");
      // var orderItem = OrderItemModel();
      // orderItem.boxes.add(boxModel);

      cartController.addItems(orderItem);
    }
  }

  //private functions
  Future<Map<String, dynamic>> _loadJsonFromAssets(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    return jsonDecode(jsonString);
  }
}
