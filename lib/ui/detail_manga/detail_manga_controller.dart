import 'package:flutter/foundation.dart';
import 'package:manga_fox_app/core/utils/setting_utils.dart';
import 'package:manga_fox_app/data/api_service.dart';
import 'package:manga_fox_app/data/response/list_chapper_response.dart';

class DetailMangaController {
  final SettingUtils settingUtils = SettingUtils();
  ValueNotifier<List<ListChapter>> chapter =
      ValueNotifier<List<ListChapter>>([]);
  ValueNotifier<List<String>> chapterCache = ValueNotifier<List<String>>([]);

  Future loadChapter(String idManga) async {
    await loadCacheChapter(idManga);
    var response = await ApiService.loadMangaListChapterResponse(idManga);
    var chapters = response?.data ?? [];
    for (var e in chapterCache.value) {
      var i = chapters.indexWhere((element) => element.sId == e);
      if (i >= 0) {
        chapters[i].isRead = true;
      }
    }
    chapter.value = chapters;
  }

  Future cacheChapter(String idManga, String chapterId) async {
    if (!chapterCache.value.contains(chapterId)) {
      chapterCache.value.add(chapterId);
      await settingUtils.setChapter(idManga, chapterCache.value);
      List<ListChapter> chapters = chapter.value;
      var i = chapters.indexWhere((element) => element.sId == chapterId);
      print(i);
      if (i >= 0) {
        chapters[i].isRead = true;
      }
      chapter.value = chapters;
    }
  }

  Future loadCacheChapter(String id) async {
    chapterCache.value = await settingUtils.getChapter(id);
  }
}
