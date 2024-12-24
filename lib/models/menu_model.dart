import 'package:pizza_app_ui_flutter/models/promo_model.dart';

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
  String name;
  final String? image;
  final int? toppingsIncluded;
  final List<Promo>? promo;
  double? discount;
  double? price;
  int? pizzaCount = 1;

  MenuItem({
    required this.id,
    required this.name,
    this.image,
    this.price,
    this.discount,
    this.pizzaCount,
    this.toppingsIncluded,
    // this.size,
    this.promo,
    // this.price,
    // this.size,
    // this.toppingsIncluded,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price']?.toDouble(),
      pizzaCount: json['pizza_count'],
      discount: json['discount']?.toDouble(),
      toppingsIncluded: json['toppings_included'],
      promo: json['promo'] != null
          ? (json['promo'] as List<dynamic>)
          .map((p) => Promo.fromJson(p as Map<String, dynamic>))
          .toList()
          : null,
      // price: (json['price'] as num?)?.toDouble(),
      // size: json['size'],
      // toppingsIncluded: json['toppings_included'],
    );
  }

  @override
  String toString() {
    return 'MenuItem{id: $id, name: $name}';
  }
}