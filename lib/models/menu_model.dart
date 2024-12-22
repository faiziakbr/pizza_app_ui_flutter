import 'package:pizza_app_ui_flutter/models/size_model.dart';
import 'package:pizza_app_ui_flutter/models/topping_model.dart';

class MenuData {
  final List<Menu> menus;

  MenuData({required this.menus});

  factory MenuData.fromJson(Map<String, dynamic> json) {
    return MenuData(
      menus: (json['menus'] as List).map((e) => Menu.fromJson(e)).toList(),
    );
  }
}

// Menu Class
class Menu {
  final String id;
  final String title;
  final String category;
  final List<MenuItem> items;

  Menu({
    required this.id,
    required this.title,
    required this.category,
    required this.items,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      items: (json['items'] as List).map((e) => MenuItem.fromJson(e)).toList(),
    );
  }

  @override
  String toString() {
    return 'Menu{id: $id, title: $title, category: $category, items: $items}';
  }
}

// MenuItem Class
class MenuItem {
  final int id;
  final String name;
  final int? toppingsIncluded;
  double? price;
  int? pizzaCount = 1;
  SizeModel? size;
  List<ToppingModel> toppings = [];
  // final double? price;
  // final String? size;
  // final int? toppingsIncluded;

  MenuItem({
    required this.id,
    required this.name,
    this.price
    this.pizzaCount,
    this.toppingsIncluded,
    this.size,
    // this.price,
    // this.size,
    // this.toppingsIncluded,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      pizzaCount: json['pizza_count'],
      toppingsIncluded: json['toppings_included'],
      // price: (json['price'] as num?)?.toDouble(),
      // size: json['size'],
      // toppingsIncluded: json['toppings_included'],
    );
  }

  @override
  String toString() {
    return 'MenuItem{id: $id, name: $name, size: $size, toppings: $toppings}';
  }
}