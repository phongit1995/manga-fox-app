import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingUtils {
  final _darkMode = "darkMode";
  final _horizontal = "horizontal";
  final _searchHistory = "_searchHistory";
  final _chap = "_chap";
  final _chapNovel = "_chapNovel";
  final _topic = "topic";
  final _initApp = "initAppTimestamp";
  final _downloadCountForDate = "downloadCountForDate";
  final _fontSizeNovel = "_fontSizeNovel";
  static int? timeInitApp;

  Future<void> setFontSizeNovel(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeNovel, size);
  }

  Future<double> getFontSizeNovel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_fontSizeNovel) ?? 13.0;
  }

  // now [0], count [1]
  Future<void> setDownloadCountForDateNow(String count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_downloadCountForDate,
        [DateFormat.yMMMEd().format(DateTime.now()), count]);
  }

  Future<int> getDownloadCountForDateNow() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      var data = (prefs.getStringList(_downloadCountForDate) ?? []);
      if(data.isNotEmpty && data[0] == DateFormat.yMMMEd().format(DateTime.now())) {
        return int.tryParse(data[1]) ?? 0;
      } else {
        setDownloadCountForDateNow("0");
        return 0;
      }
    } catch (e) {
      setDownloadCountForDateNow("0");
      return 0;
    }
  }

  Future<int?> get initApp async {
    final prefs = await SharedPreferences.getInstance();
    timeInitApp = prefs.getInt(_initApp);
    return timeInitApp;
  }

  Future<void> setInitApp() async {
    final prefs = await SharedPreferences.getInstance();
    timeInitApp = DateTime.now().millisecondsSinceEpoch;
    prefs.setInt(_initApp,
        SettingUtils.timeInitApp ?? DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> setTopic(String value, {bool isRemove = false}) async {
    final prefs = await SharedPreferences.getInstance();
    var topics = prefs.getStringList(_topic) ?? [];
    if (!topics.contains(value)) {
      if (isRemove) {
        topics.remove(value);
      } else {
        topics.add(value);
      }
    }
    await prefs.setStringList(_topic, topics);
  }

  Future<void> setChapterNovel(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_chapNovel + key, value);
  }

  Future<List<String>> getChapterNovel(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_chapNovel + key) ?? [];
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
