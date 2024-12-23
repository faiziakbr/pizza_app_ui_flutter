// Define the Topping class
import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/models/menu_model.dart';
import 'package:pizza_app_ui_flutter/models/size_model.dart';

class ToppingModel {
  final int id;
  final String name;
  final double price;
  final String image;

  ToppingModel({required this.id, required this.name, required this.price, required this.image});

  // Factory constructor to parse from JSON
  factory ToppingModel.fromJson(Map<String, dynamic> json) {
    return ToppingModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      image: json['image']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToppingModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
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
  final List<MenuItem> flavors;
  final List<SizeModel> sizes;
  final Toppings toppings;
  RxList<bool> selected = RxList<bool>();

  PizzaDetail(
      {required this.flavors, required this.sizes, required this.toppings});

  factory PizzaDetail.fromJson(Map<String, dynamic> json) {
    return PizzaDetail(
      flavors: (json['flavors'] as List<dynamic>)
          .map((e) => MenuItem.fromJson(e))
          .toList(),
      sizes: (json['sizes'] as List<dynamic>)
          .map((e) => SizeModel.fromJson(e))
          .toList(),
      toppings: Toppings.fromJson(json['toppings']),
    );
  }
}
