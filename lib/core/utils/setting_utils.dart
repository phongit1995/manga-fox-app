import 'package:shared_preferences/shared_preferences.dart';

class SettingUtils{
  final _darkMode = "darkMode";
  final _horizontal = "horizontal";

  Future<bool> get dartMode async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkMode) ?? false;
  }

  Future<void>  setDartMode(bool value) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_darkMode, value);
  }

  Future<void>  setHorizontal(bool value) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_horizontal, value);
  }

  Future<bool> get horizontal async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_horizontal) ?? true;
  }
}