import 'package:flutter/foundation.dart';
import 'package:manga_fox_app/data/api_service.dart';
import 'package:manga_fox_app/data/response/generate_response.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';

class HomeController {
  ValueNotifier<List<Generate>> generates = ValueNotifier<List<Generate>>([]);
  ValueNotifier<List<Manga>> topManga = ValueNotifier<List<Manga>>([]);
  ValueNotifier<List<Manga>> lastManga = ValueNotifier<List<Manga>>([]);
  ValueNotifier<List<Manga>> exManga = ValueNotifier<List<Manga>>([]);

  Future loadGenerate() async {
    var response = await ApiService.loadGenerateResponse();
    generates.value = response?.data ?? [];
  }

  Future loadTopManga() async {
    var response = await ApiService.loadMangaResponse(0);
    topManga.value = response?.data ?? [];
  }

  Future loadLastManga() async {
    var response = await ApiService.loadMangaResponse(1);
    lastManga.value = response?.data ?? [];
  }

  Future loadExManga() async {
    var response = await ApiService.loadMangaExclusivelyResponse();
    exManga.value = response?.data ?? [];
  }

  static final HomeController _singleton = HomeController._internal();

  factory HomeController() {
    return _singleton;
  }

  HomeController._internal();
}
