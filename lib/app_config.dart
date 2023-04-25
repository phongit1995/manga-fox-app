import 'dart:io';

class AppConfig {
  static String baseApiUrl = Platform.isAndroid ? baseApiUrlAndroid : baseApiUrlIos;
  
  static const String baseApiUrlAndroid= 'https://manga-reader-android-v21.readingnovelfull.com/';
  static const String baseApiUrlIos= 'https://manga-reader-ios-v5.readingnovelfull.com/';

  static const String androidId = "reader.app.free.manga.reader";
  static const String iosId = "manga.fox.manga.reader.free";
  static const String urlFacebook =
      "https://www.facebook.com/groups/%20mangamanhwaanime";
  static const String urlTerm =
      "https://manga-reader-6734b.firebaseapp.com/privacy-policy.html";
  static const String urlStoreAndroid =
      "https://play.google.com/store/apps/details?id=$androidId";
  static const String urlStoreIos = "https://apps.apple.com/app/id$iosId";

  //APPLOVIN config
  static String APPLOVIN_SDK_KEY =
      'o76oOvpIrLCJEhI9iVJm6ZGfW7dLTtygvErJpweFwfnfz2towWZBk000snxdhamHLP9pT5INWM8vr3na-QqOi1';
  

  static String APPLOVIN_INTERSTITAL_AD_UNIT = Platform.isAndroid ?  APPLOVIN_INTERSTITAL_AD_UNIT_ANDROID : APPLOVIN_INTERSTITAL_AD_UNIT_IOS;
  static String APPLOVIN_INTERSTITAL_AD_UNIT_ANDROID = '4aa5a3f74f6a300a';

  static String APPLOVIN_INTERSTITAL_AD_UNIT_IOS = '697b37b429068eff';

  //Count click to show ads
  static int countClickAction = 5;
  static int loadAdsClickAction = 4;
  static int limitDownload = 10;

  static List<String> iapSubscription = Platform.isAndroid
      ? [
          "reader.app.free.manga.reader.one.month",
          "reader.app.free.manga.reader.one.year"
        ]
      : [];
}
