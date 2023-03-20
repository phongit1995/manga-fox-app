import 'dart:ui';

import 'package:manga_fox_app/app_config.dart';
import 'package:manga_fox_app/applovin.dart';
import 'package:manga_fox_app/core/app_setting.dart';

class HandlerAction {
  int _countClickAction = 3;

  Future handlerAction(VoidCallback action, {bool handlerAds = true}) async {
    if (handlerAds && !AppSettingData().userPremium.value) {
      _countClickAction++;
      if (_countClickAction % AppConfig.loadAdsClickAction == 0) {
        applovinServiceAds.loadInterstital();
      }
      if (_countClickAction % AppConfig.countClickAction == 0) {
        await applovinServiceAds.showInterstital();
      }
    }
    action();
  }

  static final HandlerAction _singleton = HandlerAction._internal();

  factory HandlerAction() {
    return _singleton;
  }

  HandlerAction._internal();
}
