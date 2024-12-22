// Define the Topping class
import 'package:pizza_app_ui_flutter/models/size_model.dart';

class ToppingModel {
  final int id;
  final String name;
  final double price;

  ToppingModel({required this.id, required this.name, required this.price});

  // Factory constructor to parse from JSON
  factory ToppingModel.fromJson(Map<String, dynamic> json) {
    return ToppingModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}

class Toppings {
  final List<ToppingModel> vegetarian;
  final List<ToppingModel> nonVegetarian;

  Toppings({required this.vegetarian, required this.nonVegetarian});

  factory Toppings.fromJson(Map<String, dynamic> json) {
    return Toppings(
      vegetarian: (json['vegetarian'] as List<dynamic>)
          .map((e) => ToppingModel.fromJson(e))
          .toList(),
      nonVegetarian: (json['non_vegetarian'] as List<dynamic>)
          .map((e) => ToppingModel.fromJson(e))
          .toList(),
    );
  }
}


class PizzaDetail {
  final List<SizeModel> sizes;
  final Toppings toppings;

  PizzaDetail({required this.sizes, required this.toppings});

  factory PizzaDetail.fromJson(Map<String, dynamic> json) {
    return PizzaDetail(
      sizes: (json['sizes'] as List<dynamic>)
          .map((e) => SizeModel.fromJson(e))
          .toList(),
      toppings: Toppings.fromJson(json['toppings']),
    );
  }
}