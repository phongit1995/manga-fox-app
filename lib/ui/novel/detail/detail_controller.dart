import 'package:flutter/foundation.dart';
import 'package:manga_fox_app/core/utils/setting_utils.dart';
import 'package:manga_fox_app/data/api_service_novel.dart';
import 'package:manga_fox_app/data/dao/chapter_novel_dao.dart';
import 'package:manga_fox_app/data/response/novel_chapter.dart';

class DetailController {
  final SettingUtils settingUtils = SettingUtils();
  ValueNotifier<List<NovelChapter>> chapter =
      ValueNotifier<List<NovelChapter>>([]);
  bool revert = false;
  ValueNotifier<List<String>> chapterCache = ValueNotifier<List<String>>([]);

  Future loadChapterLocal(String idManga) async {
    await loadCacheChapter(idManga);
    var chapters = ChapterNovelDAO().getListChapter(idManga);
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
    var response = await ApiServiceNovel.loadMangaListChapterResponse(idManga);
    var chapters = response?.data ?? [];
    if(chapters.isEmpty && chapter.value.isNotEmpty) {
      return;
    }
    ChapterNovelDAO().addListChapter(chapters, idManga);
    for (var e in chapterCache.value) {
      var i = chapters.indexWhere((element) => element.sId == e);
      if (i >= 0) {
        chapters[i].isRead = true;
      }
    }
    print(chapters.length);

    chapter.value = chapters;
  }

  Future cacheChapter(String idManga, String chapterId) async {
    if (!chapterCache.value.contains(chapterId)) {
      chapterCache.value.add(chapterId);
      await settingUtils.setChapterNovel(idManga, chapterCache.value);
      List<NovelChapter> chapters = chapter.value;
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
    chapterCache.value = await settingUtils.getChapterNovel(id);
  }
}
