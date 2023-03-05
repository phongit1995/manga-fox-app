import 'dart:ui';

import 'package:manga_fox_app/app_config.dart';
import 'package:manga_fox_app/applovin.dart';

class HandlerAction {
  int _countClickAction = 0;

  Future handlerAction(VoidCallback action, {bool handlerAds = true}) async {
    if (handlerAds) {
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
