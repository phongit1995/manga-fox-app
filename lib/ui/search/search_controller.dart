import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/utils/setting_utils.dart';
import 'package:manga_fox_app/data/api_service.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';

class SearchController {
  final SettingUtils settingUtils = SettingUtils();
  final ValueNotifier<String> title = ValueNotifier<String>('');
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<String>> searchHistory =
      ValueNotifier<List<String>>([]);
  final ValueNotifier<List<Manga>> results = ValueNotifier<List<Manga>>([]);

  Future loadCategoryManga(String category) async {
    isLoading.value = true;
    var response = await ApiService.loadMangaCategoryResponse(category);
    results.value = response?.data ?? [];
    isLoading.value = false;
  }

  Future getSearchHistory() async {
    searchHistory.value = await settingUtils.searchHistory;
  }

  Future setSearchHistory(String value) async {
    if (value.trim().isEmpty) {
      return;
    }
    if (searchHistory.value.contains(value.toLowerCase())) {
      return;
    }
    searchHistory.value.add(value.toLowerCase());
    await settingUtils.setSearchHistory(searchHistory.value);
    searchHistory.value = await settingUtils.searchHistory;
  }

  Future search(String value) async {
    isLoading.value = true;
    results.value = (await ApiService.searchMangaResponse(value))?.data ?? [];
    isLoading.value = false;
  }
}
