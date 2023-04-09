import 'package:flutter/material.dart';

class AppColor extends ThemeExtension<AppColor> {
  final Color primaryBlack;
  final Color primaryBlack2;
  final Color primaryBlack3;
  final Color primaryBackground;
  final Color backgroundWhite;
  final Color backgroundWhite2;
  final Color backgroundBottomNavigator;
  final Color activeBottomNavigator;
  final Color primaryDivider;
  final Color backgroundTabBar;
  final Color shimmerLoadingBase;
  final Color shimmerLoadingHighlight;
  final Color indicatorBanner;
  final Color primary;
  final Color yellow;

  AppColor({
    required this.shimmerLoadingBase,
    required this.shimmerLoadingHighlight,
    required this.primaryBackground,
    required this.backgroundBottomNavigator,
    required this.backgroundTabBar,
    required this.primaryBlack2,
    required this.primaryBlack3,
    required this.primaryDivider,
    required this.primaryBlack,
    required this.activeBottomNavigator,
    required this.backgroundWhite,
    required this.backgroundWhite2,
    required this.indicatorBanner,
    required this.primary,
    required this.yellow,
  });

  @override
  AppColor copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  ThemeExtension<AppColor> lerp(ThemeExtension<AppColor>? other, double t) {
    return AppColor(
        shimmerLoadingBase: shimmerLoadingBase,
        shimmerLoadingHighlight: shimmerLoadingHighlight,
        primaryBackground: primaryBackground,
        backgroundBottomNavigator: backgroundBottomNavigator,
        backgroundTabBar: backgroundTabBar,
        primaryBlack2: primaryBlack2,
        primaryBlack3: primaryBlack3,
        primaryDivider: primaryDivider,
        primaryBlack: primaryBlack,
        activeBottomNavigator: activeBottomNavigator,
        backgroundWhite: backgroundWhite,
        backgroundWhite2: backgroundWhite2,
        indicatorBanner: indicatorBanner,
        yellow: yellow,
        primary: primary);
  }
}
