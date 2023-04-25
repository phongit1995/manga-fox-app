import 'package:applovin_max/applovin_max.dart';
import 'package:manga_reader_app/app_config.dart';
import 'package:manga_reader_app/config.dart';

class ApplovinService {

  Future<void> initApplovin() async {
    Map? configuration =
        await AppLovinMAX.initialize(AppConfig.APPLOVIN_SDK_KEY);
    attachAdListeners();
  }

  void loadInterstital() {
    AppLovinMAX.loadInterstitial(
        AppConfig.APPLOVIN_INTERSTITAL_AD_UNIT);
  }

  void attachAdListeners() {
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {},
      onAdLoadFailedCallback: (adUnitId, error) {},
      onAdDisplayedCallback: (ad) {},
      onAdDisplayFailedCallback: (ad, error) {},
      onAdClickedCallback: (ad) {},
      onAdHiddenCallback: (ad) {},
    ));
  }

  Future<void> showInterstital() async {
    bool isReady = (await AppLovinMAX.isInterstitialReady(
            AppConfig.APPLOVIN_INTERSTITAL_AD_UNIT)) ??
        false;
    if (isReady) {
      AppLovinMAX.showInterstitial(
          AppConfig.APPLOVIN_INTERSTITAL_AD_UNIT);
    }
  }
}

final applovinServiceAds = ApplovinService();
