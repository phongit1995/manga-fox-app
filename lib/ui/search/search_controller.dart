import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/utils/setting_utils.dart';
import 'package:manga_fox_app/data/api_service.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';

class SearchController {
  final SettingUtils settingUtils = SettingUtils();
  final ValueNotifier<String> title = ValueNotifier<String>('');
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  String textSearch = '';
  String category = '';
  int currentPage = 1;
  final ValueNotifier<List<String>> searchHistory =
      ValueNotifier<List<String>>([]);
  final ValueNotifier<List<Manga>> results = ValueNotifier<List<Manga>>([]);
  final canLoad = ValueNotifier<bool>(true);
  final loadMore = ValueNotifier<bool>(false);

  Future loadCategoryManga(String category) async {
    isLoading.value = true;
    currentPage = 1;
    var response = await ApiService.loadMangaCategoryResponse(category);
    if ((response?.data ?? []).isEmpty) {
      canLoad.value = false;
    } else {
      canLoad.value = true;
    }
    this.category = category;
    results.value = response?.data ?? [];
    isLoading.value = false;
  }

  Future loadMoreCategoryManga() async {
    if(!canLoad.value || results.value.isEmpty) return;
    loadMore.value = true;
    canLoad.value = false;
    var response = (await ApiService.loadMangaCategoryResponse(category, page: currentPage))?.data ?? [];
    if (response.isEmpty) {
      canLoad.value = false;
    } else {
      currentPage++;
      var data = results.value;
      data.addAll(response);
      results.value = data;
      results.notifyListeners();
      canLoad.value = true;
    }
    loadMore.value = false;
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

  Future loadMoreSearch() async {
    if(!canLoad.value || results.value.isEmpty) return;
    loadMore.value = true;
    canLoad.value = false;
    var response = (await ApiService.searchMangaResponse(textSearch, page: currentPage))?.data ?? [];
    if (response.isEmpty) {
      canLoad.value = false;
    } else {
      currentPage++;
      var data = results.value;
      data.addAll(response);
      results.value = data;
      results.notifyListeners();
      canLoad.value = true;
    }
    loadMore.value = false;
  }

  Future search(String value) async {
    isLoading.value = true;
    currentPage = 1;
    results.value = (await ApiService.searchMangaResponse(value))?.data ?? [];
    currentPage++;
    textSearch = value;
    isLoading.value = false;
  }
}
