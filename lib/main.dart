import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/theme/theme_data.dart';

import 'AppBinding.dart';
import 'routes/app_pages.dart';
import 'theme/ThemeController.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: true,
      initialRoute: Routes.HOME,
      defaultTransition: Transition.cupertino,
      getPages: AppPages.routes,
      initialBinding: AppBinding(),
      smartManagement: SmartManagement.keepFactory,
      title: 'Pizza App',
      themeMode: ThemeMode.dark,

      // theme: ThemeConfig.myLightTheme,
      // darkTheme: ThemeConfig.myDarkTheme,
      // themeMode: Get.put(ThemeController(), permanent: true).isDarkMode.value
      //     ? ThemeMode.dark
      //     : ThemeMode.light,
      // locale: TranslationService.locale,
      // fallbackLocale: TranslationService.fallbackLocale,
      // translations: TranslationService(),
      // builder: EasyLoading.init(),
    );
  }
}
