import 'package:flutter/material.dart';

const Map<int, Color> color = {
  50: Color.fromRGBO(31, 29, 54, .1),
  100: Color.fromRGBO(31, 29, 54, .2),
  200: Color.fromRGBO(31, 29, 54, .3),
  300: Color.fromRGBO(31, 29, 54, .4),
  400: Color.fromRGBO(31, 29, 54, .5),
  500: Color.fromRGBO(31, 29, 54, .6),
  600: Color.fromRGBO(31, 29, 54, .7),
  700: Color.fromRGBO(31, 29, 54, .8),
  800: Color.fromRGBO(31, 29, 54, .9),
  900: Color.fromRGBO(31, 29, 54, 1),
};

class AppColor {
  // Prevent instance creation
  const AppColor._();
  static const MaterialColor primaryMaterial = MaterialColor(0xFFFFFFFF, color);
  static const Color primary = Color(0xFFFFFFFF);
  static const Color primaryAccent = Color(0xFF515052);
  static const Color secondaryColor = Color(0xFFFD7F2C);
  static const Color secondaryAccent = Color(0XFFFDA766);

  static const Color thirdColor = Color(0xFF333138);
  static const Color successColor = Color(0xFF487d3e);
  static const Color failureColor = Color(0xFFd11938);
}
