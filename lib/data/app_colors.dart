import 'dart:ui';

import 'package:flutter/material.dart';

class AppColor extends ThemeExtension<AppColor> {
  final Color primaryBlack;
  final Color primaryBackground;
  final Color backgroundWhite;
  final Color backgroundBottomNavigator;
  final Color activeBottomNavigator;
  final Color primaryDivider;

  AppColor({
    required this.primaryBackground,
    required this.backgroundBottomNavigator,
    required this.primaryDivider,
    required this.primaryBlack,
    required this.activeBottomNavigator,
    required this.backgroundWhite,
  });

  @override
  AppColor copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  ThemeExtension<AppColor> lerp(ThemeExtension<AppColor>? other, double t) {
    // TODO: implement lerp
    throw UnimplementedError();
  }
}
