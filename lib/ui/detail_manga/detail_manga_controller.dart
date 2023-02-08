import 'package:flutter/foundation.dart';
import 'package:manga_fox_app/data/api_service.dart';
import 'package:manga_fox_app/data/response/list_chapper_response.dart';

class DetailMangaController {

  ValueNotifier<List<ListChapter>> chapter = ValueNotifier<List<ListChapter>>([]);

  Future loadChapter(String idManga) async {
    var response = await ApiService.loadMangaListChapterResponse(idManga);
    chapter.value = response?.data ?? [];
  }
}