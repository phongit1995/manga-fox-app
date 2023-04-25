import 'package:flutter/foundation.dart';
import 'package:manga_reader_app/core/utils/setting_utils.dart';
import 'package:manga_reader_app/data/api_service.dart';
import 'package:manga_reader_app/data/dao/chapter_dao.dart';
import 'package:manga_reader_app/data/response/list_chapper_response.dart';

class DetailMangaController {
  final SettingUtils settingUtils = SettingUtils();
  ValueNotifier<List<ListChapter>> chapter =
      ValueNotifier<List<ListChapter>>([]);
  bool revert = false;
  ValueNotifier<List<String>> chapterCache = ValueNotifier<List<String>>([]);

  Future loadChapterLocal(String idManga) async {
    await loadCacheChapter(idManga);
    var chapters = ChapterDAO().getListChapter(idManga);
    for (var e in chapterCache.value) {
      var i = chapters.indexWhere((element) => element.sId == e);
      if (i >= 0) {
        chapters[i].isRead = true;
      }
    }
    chapter.value = chapters;
  }

  Future loadChapter(String idManga) async {
    await loadCacheChapter(idManga);
    var response = await ApiService.loadMangaListChapterResponse(idManga);
    var chapters = response?.data ?? [];
    if(chapters.isEmpty && chapter.value.isNotEmpty) {
      return;
    }
    ChapterDAO().addListChapter(chapters, idManga);
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
      if (i >= 0) {
        chapters[i].isRead = true;
      }
      chapters.sort(
            (a, b) {
          if ((a.index ?? 0) > (b.index ?? 0)) {
            return 1;
          } else {
            return 0;
          }
        },
      );
      chapter.value = chapters;
    }
  }

  Future loadCacheChapter(String id) async {
    chapterCache.value = await settingUtils.getChapter(id);
  }
}
