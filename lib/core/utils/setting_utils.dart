import 'package:shared_preferences/shared_preferences.dart';

class SettingUtils {
  final _darkMode = "darkMode";
  final _horizontal = "horizontal";
  final _searchHistory = "_searchHistory";
  final _chap = "_chap";
  final _topic = "topic";
  final _initApp = "initApp";

  Future<bool> get initApp async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_initApp) ?? true;
  }

  Future<void> setInitApp() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_initApp, false);
  }

  Future<void> setTopic(String value, {bool isRemove = false}) async {
    final prefs = await SharedPreferences.getInstance();
    var topics = prefs.getStringList(_topic) ?? [];
    if(!topics.contains(value)) {
      if(isRemove) {
        topics.remove(value);
      } else {
        topics.add(value);
      }
    }
    await prefs.setStringList(_topic, topics);
  }

  Future<void> setChapter(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_chap + key, value);
  }

  Future<List<String>> getChapter(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_chap + key) ?? [];
  }

  Future<void> setSearchHistory(List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_searchHistory, value);
  }

  Future<List<String>> get searchHistory async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_searchHistory) ?? [];
  }

  Future<bool> get dartMode async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkMode) ?? false;
  }

  Future<void> setDartMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_darkMode, value);
  }

  Future<void> setHorizontal(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_horizontal, value);
  }

  Future<bool> get horizontal async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_horizontal) ?? true;
  }
}
