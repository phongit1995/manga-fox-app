import 'package:flutter/foundation.dart';
import 'package:manga_fox_app/data/api_service_novel.dart';
import 'package:manga_fox_app/data/response/generate_response.dart';
import 'package:manga_fox_app/data/response/novel_response.dart';

class NovelController {
  ValueNotifier<List<Generate>> generates = ValueNotifier<List<Generate>>([]);
  ValueNotifier<List<Novel>> novels = ValueNotifier<List<Novel>>([]);
  ValueNotifier<String> genres = ValueNotifier<String>('');
  ValueNotifier<String> genresSelect = ValueNotifier<String>('');

  Future loadGenerate() async {
    var response = await ApiServiceNovel.loadGenerateResponse();
    generates.value = response?.data ?? [];
  }

  Future loadMangas(String category) async {
    var response = await ApiServiceNovel.loadMangaCategoryResponse(category,
        numberItem: 500);
    genres.value = category;
    novels.value = response?.data ?? [];
  }

  static final NovelController _singleton = NovelController._internal();

  factory NovelController() {
    return _singleton;
  }

  NovelController._internal();
}
