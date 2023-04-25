import 'dart:ui';

import 'package:manga_reader_app/app_config.dart';
import 'package:manga_reader_app/applovin.dart';
import 'package:manga_reader_app/core/app_setting.dart';
import 'package:manga_reader_app/core/inapp_review.helper.dart';

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
    InAppReviewHelper().requestReview();
  }

  static final HandlerAction _singleton = HandlerAction._internal();

  factory HandlerAction() {
    return _singleton;
  }

  HandlerAction._internal();
}
