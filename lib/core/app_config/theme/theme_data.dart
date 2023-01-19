import 'package:flutter/material.dart';
import 'package:manga_fox_app/data/app_colors.dart';

class AppThemData {
  static ThemeData light =
      ThemeData(fontFamily: "Lexend", extensions: <ThemeExtension<AppColor>>[
    AppColor(
      primaryBackground: const Color(0xffFFFAF5),
      backgroundWhite: const Color(0xffFFFFFF),
      activeBottomNavigator: const Color(0xff4B526C),
      primaryBlack: const Color(0xff000000),
      primaryDivider: const Color(0xff626262),
      backgroundBottomNavigator: const Color(0xFFFFFFFF),
    )
  ]);

  static ThemeData dark =
      ThemeData(fontFamily: "Lexend", extensions: <ThemeExtension<dynamic>>[
    AppColor(
      primaryBackground: const Color(0xff333333),
      backgroundWhite: const Color(0xff3A3A3A),
      primaryBlack: const Color(0xffFFFFFF),
      primaryDivider: const Color(0xffFFECEC),
      backgroundBottomNavigator: const Color(0xFF262626),
      activeBottomNavigator: const Color(0xffFFFFFF),
    )
  ]);
}
