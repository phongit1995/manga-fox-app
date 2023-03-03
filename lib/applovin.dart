import 'package:applovin_max/applovin_max.dart';
import 'package:manga_fox_app/config.dart';
class ApplovinService {
  Future<void> initApplovin() async {
    Map? configuration = await AppLovinMAX.initialize(ConfigService.APPLOVIN_SDK_KEY);
    if (configuration != null) {
        print("SDK Initialized: $configuration");
    }
    this.attachAdListeners();
  }
  void loadInterstital(){
    AppLovinMAX.loadInterstitial(ConfigService.APPLOVIN_INTERSTITAL_AD_UNIT_ANDROID);
  }
  void attachAdListeners(){
    AppLovinMAX.setInterstitialListener(InterstitialListener(
        onAdLoadedCallback: (ad) {
            // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialReady(_interstitial_ad_unit_id) will now return 'true'
            print('Interstitial ad loaded from ' + ad.networkName);

            // Reset retry attempt
        },
        onAdLoadFailedCallback: (adUnitId, error) {
            // Interstitial ad failed to load
            // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        },
        onAdDisplayedCallback: (ad) {
            
        },
        onAdDisplayFailedCallback: (ad, error) {
           
        },
        onAdClickedCallback: (ad) {
            
        },
        onAdHiddenCallback: (ad) {
            
        },
    ));
  }
  Future<void> showInterstital()async{
    bool isReady = (await AppLovinMAX.isInterstitialReady(ConfigService.APPLOVIN_INTERSTITAL_AD_UNIT_ANDROID))!;
    if(isReady){
      AppLovinMAX.showInterstitial(ConfigService.APPLOVIN_INTERSTITAL_AD_UNIT_ANDROID);
    }
  }
}
final applovinServiceAds = ApplovinService();