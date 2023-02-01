import 'dart:ui';

import 'package:flutter/material.dart';

class AppColor extends ThemeExtension<AppColor> {
  final Color primaryBlack;
  final Color primaryBlack2;
  final Color primaryBackground;
  final Color backgroundWhite;
  final Color backgroundWhite2;
  final Color backgroundBottomNavigator;
  final Color activeBottomNavigator;
  final Color primaryDivider;

  AppColor({
    required this.primaryBackground,
    required this.backgroundBottomNavigator,
    required this.primaryBlack2,
    required this.primaryDivider,
    required this.primaryBlack,
    required this.activeBottomNavigator,
    required this.backgroundWhite,
    required this.backgroundWhite2,
  });

  @override
  AppColor copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  ThemeExtension<AppColor> lerp(ThemeExtension<AppColor>? other, double t) {
    return AppColor(
        primaryBackground: primaryBackground,
        backgroundBottomNavigator: backgroundBottomNavigator,
        primaryBlack2: primaryBlack2,
        primaryDivider: primaryDivider,
        primaryBlack: primaryBlack,
        activeBottomNavigator: activeBottomNavigator,
        backgroundWhite: backgroundWhite,
        backgroundWhite2: backgroundWhite2);
  }
}
