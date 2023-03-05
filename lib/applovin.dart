import 'package:applovin_max/applovin_max.dart';
import 'package:manga_fox_app/config.dart';

class ApplovinService {

  Future<void> initApplovin() async {
    Map? configuration =
        await AppLovinMAX.initialize(ConfigService.APPLOVIN_SDK_KEY);
    attachAdListeners();
  }

  void loadInterstital() {
    AppLovinMAX.loadInterstitial(
        ConfigService.APPLOVIN_INTERSTITAL_AD_UNIT_ANDROID);
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
            ConfigService.APPLOVIN_INTERSTITAL_AD_UNIT_ANDROID)) ??
        false;
    if (isReady) {
      AppLovinMAX.showInterstitial(
          ConfigService.APPLOVIN_INTERSTITAL_AD_UNIT_ANDROID);
    } else {
      loadInterstital();
      if ((await AppLovinMAX.isInterstitialReady(
              ConfigService.APPLOVIN_INTERSTITAL_AD_UNIT_ANDROID)) ??
          false) {
        AppLovinMAX.showInterstitial(
            ConfigService.APPLOVIN_INTERSTITAL_AD_UNIT_ANDROID);
      }
    }
  }
}

final applovinServiceAds = ApplovinService();
