import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/modules/cart/cart_screen.dart';
import 'package:pizza_app_ui_flutter/modules/home/home_binding.dart';
import 'package:pizza_app_ui_flutter/modules/home/home_screen.dart';
import 'package:pizza_app_ui_flutter/modules/selection/selection_binding.dart';
import 'package:pizza_app_ui_flutter/modules/selection/selection_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
        name: Routes.SELECTION,
        page: () => const SelectionScreen(),
        binding: SelectionBinding()),
    GetPage(name: Routes.CART, page: () => const CartScreen())
  ];
}
