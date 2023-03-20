import 'package:flutter/material.dart';

class AppSettingData {
  AppSettingData._internal();

  static final AppSettingData _singleton = AppSettingData._internal();

  factory AppSettingData() {
    return _singleton;
  }

  final ValueNotifier<bool> userPremium = ValueNotifier<bool>(false);

  void updateIsVip(bool update) {
    userPremium.value = update;
  }
}
