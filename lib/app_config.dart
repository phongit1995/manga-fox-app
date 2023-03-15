class AppConfig {
  static const String baseApiUrl= 'https://manga-reader-android-v13.readingnovelfull.com/';
  static const String androidId = "manga.fox.manga.reader.free";
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
  static String APPLOVIN_INTERSTITAL_AD_UNIT_ANDROID = '79a8949388c3e814';

  //Count click to show ads
  static int countClickAction = 5;
  static int loadAdsClickAction = 4;
}
