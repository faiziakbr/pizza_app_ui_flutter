import 'package:flutter/material.dart';

class ColorConstants {
  static const Color lightScaffoldBackgroundColor = Color(0xF9F9F9);
  static const Color darkScaffoldBackgroundColor = Color(0x2F2E2E);
  static const Color secondaryAppColor = Color(0x22DDA6);
  static const Color secondaryDarkAppColor = Colors.white;
  static const Color tipColor = Color(0xB6B6B6);
  static const Color lightGray = Color(0xFFF6F6F6);
  static const Color darkGray = Color(0xFF9F9F9F);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
}

// Color hexToColor(String hex) {
//   assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
//       'hex color must be #rrggbb or #rrggbbaa');
//
//   return Color(
//     int.parse(hex.substring(1), radix: 16) +
//         (hex.length == 7 ? 0xff000000 : 0x00000000),
//   );
// }
