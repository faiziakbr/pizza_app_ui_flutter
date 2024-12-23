import 'package:pizza_app_ui_flutter/models/menu_model.dart';
import 'package:pizza_app_ui_flutter/models/size_model.dart';
import 'package:pizza_app_ui_flutter/models/topping_model.dart';

class OrderModel {
  List<OrderItemModel> orderItems = [];
  double? total = 0;
  // OrderModel(this.orderItems);
}

class OrderItemModel {
  List<PizzaModel> items = [];
  int required = 0;
  double? price; // Total calculated price OR discountedPrice
  double? actualPrice = 0; //Total calculated price
  bool isPromoPrice = false;
  String? image;
  // double? displayPrice = 0;
  int count = 1;

  @override
  String toString() {
    return 'BoxModel{items: $items, required: $required, price: $price, actualPrice: $actualPrice, isPromoPrice: $isPromoPrice, image: $image}';
  } //Can be image of promo or single pizza

}

class PizzaModel {
  String? name;
  String? image;
  int maxToppings = 0;
  String? size;
  double? sizePrice;
  List<ToppingModel> vegToppings = [];
  List<ToppingModel> nonBegToppings = [];

  @override
  String toString() {
    return 'PizzaModel{name: $name, image: $image, maxToppings: $maxToppings, size: $size, sizePrice: $sizePrice, vegToppings: $vegToppings, nonBegToppings: $nonBegToppings}';
  }
}

class Tuple {
  bool status;
  String message;

  Tuple(this.status, this.message);
}