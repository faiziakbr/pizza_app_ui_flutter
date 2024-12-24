import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/theme/theme_data.dart';

class ThemeController extends GetxController with WidgetsBindingObserver {
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize theme based on the current platform brightness
    _setThemeFromSystem();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // Update theme when system theme changes
    _setThemeFromSystem();
  }

  void _setThemeFromSystem() {
    final brightness = WidgetsBinding.instance.window.platformBrightness;

    isDarkMode.value = brightness == Brightness.dark;
    Get.changeTheme(
        isDarkMode.value ? ThemeConfig.darkTheme : ThemeConfig.lightTheme);
  }
}
