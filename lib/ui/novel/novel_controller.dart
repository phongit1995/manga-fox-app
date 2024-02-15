import 'package:flutter/foundation.dart';
import 'package:manga_fox_app/data/api_service_novel.dart';
import 'package:manga_fox_app/data/response/generate_response.dart';
import 'package:manga_fox_app/data/response/novel_response.dart';

class NovelController {
  ValueNotifier<List<Generate>> generates = ValueNotifier<List<Generate>>([]);
  ValueNotifier<List<Novel>> novels = ValueNotifier<List<Novel>>([]);
  ValueNotifier<String> genres = ValueNotifier<String>('');
  ValueNotifier<String> genresSelect = ValueNotifier<String>('');

  final canLoad = ValueNotifier<bool>(true);
  final loadMore = ValueNotifier<bool>(false);
  int currentPage = 1;

  Future loadGenerate() async {
    var response = await ApiServiceNovel.loadGenerateResponse();
    generates.value = response?.data ?? [];
  }

  Future loadMangas(String category) async {
    currentPage = 1;
    novels.value = [];
    var response = await ApiServiceNovel.loadMangaCategoryResponse(category);
    genres.value = category;
    novels.value = response?.data ?? [];

    if ((response?.data ?? []).isEmpty) {
      canLoad.value = false;
    } else {
      canLoad.value = true;
    }
    currentPage ++;
  }

  Future loadMoreMangas() async {
    if(!canLoad.value || novels.value.isEmpty) return;
    loadMore.value = true;
    canLoad.value = false;
    var response = (await ApiServiceNovel.loadMangaCategoryResponse(genres.value, page: currentPage))?.data ?? [];
    if (response.isEmpty) {
      canLoad.value = false;
    } else {
      currentPage++;
      var data = novels.value;
      data.addAll(response);
      novels.value = data;
      novels.notifyListeners();
      canLoad.value = true;
    }
    loadMore.value = false;
  }

  static final NovelController _singleton = NovelController._internal();

  factory NovelController() {
    return _singleton;
  }

  NovelController._internal();
}
