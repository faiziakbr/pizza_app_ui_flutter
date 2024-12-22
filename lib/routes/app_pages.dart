
import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/modules/home/home_binding.dart';
import 'package:pizza_app_ui_flutter/modules/home/home_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    // GetPage(
    //   name: Routes.AUTH,
    //   page: () => AuthScreen(),
    //   binding: AuthBinding(),
    //   children: [
    //     GetPage(name: Routes.REGISTER, page: () => RegisterScreen()),
    //     GetPage(name: Routes.LOGIN, page: () => LoginScreen()),
    //   ],
    // ),
    // GetPage(
    //     name: Routes.HOME,
    //     page: () => HomeScreen(),
    //     binding: HomeBinding(),
    //     children: [
    //       GetPage(name: Routes.CARDS, page: () => CardsScreen()),
    //     ]),
  ];
}
