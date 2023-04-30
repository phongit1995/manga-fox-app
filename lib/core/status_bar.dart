import 'package:flutter/services.dart';

class StatusBarCommon{
  StatusBarCommon._internal();

  static final StatusBarCommon _singleton = StatusBarCommon._internal();

  factory StatusBarCommon() {
    return _singleton;
  }

  void showStatusBarReadManga(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }
  void showCurrentStatusBar(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }
}
