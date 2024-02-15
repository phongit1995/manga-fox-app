import 'package:flutter/material.dart';
import 'package:manga_fox_app/data/api_service.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';

class GenresController {
  ValueNotifier<List<Manga>> mangas = ValueNotifier<List<Manga>>([]);
  ValueNotifier<String> genres = ValueNotifier<String>('');
  ValueNotifier<String> genresSelect = ValueNotifier<String>('');

  final canLoad = ValueNotifier<bool>(true);
  final loadMore = ValueNotifier<bool>(false);
  int currentPage = 1;

  Future loadMangas(String category) async {
    currentPage = 1;
    mangas.value = [];
    var response = await ApiService.loadMangaCategoryResponse(category);
    if ((response?.data ?? []).isEmpty) {
      canLoad.value = false;
    } else {
      canLoad.value = true;
    }
    currentPage ++;
    genres.value = category;
    mangas.value = response?.data ?? [];
  }

  Future loadMoreCategoryManga() async {
    if(!canLoad.value || mangas.value.isEmpty) return;
    loadMore.value = true;
    canLoad.value = false;
    var response = (await ApiService.loadMangaCategoryResponse(genres.value, page: currentPage))?.data ?? [];
    if (response.isEmpty) {
      canLoad.value = false;
    } else {
      currentPage++;
      var data = mangas.value;
      data.addAll(response);
      mangas.value = data;
      mangas.notifyListeners();
      canLoad.value = true;
    }
    loadMore.value = false;
  }
}
