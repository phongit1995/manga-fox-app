import 'package:hive/hive.dart';
import 'package:manga_fox_app/data/response/list_chapper_response.dart';

class ChapterDAO {
  final chapterDao = "chapter";
  final chapterReadingDao = "chapterReadingDao";
  final chapterPercentReadingDao = "chapterPercentReadingDao";

  void addPercentChapterReading(String chapterId, double p) {
    if(chapterId.isEmpty) return;
    var box = Hive.box(chapterPercentReadingDao);
    box.put(chapterId, p);
  }

  double? getPercentChapterReading(String chapterId) {
    var box = Hive.box(chapterPercentReadingDao);
    return double.tryParse(box.get(chapterId)?.toString() ?? '0');
  }

  void addReading(String chapterId, String mangaId) {
    if(chapterId.isEmpty || mangaId.isEmpty) return;
    var box = Hive.box(chapterReadingDao);
    box.put(mangaId, chapterId);
  }

  String? getReading(String mangaId) {
    var box = Hive.box(chapterReadingDao);
    return box.get(mangaId)?.toString();
  }


  void addListChapter(List<ListChapter> chapter, String mangaId) {
    if(mangaId.isEmpty || chapter.isEmpty) return;
    var box = Hive.box(chapterDao);
    box.put(mangaId, chapter);
  }

  List<ListChapter> getListChapter(String mangaId) {
    var box = Hive.box(chapterDao);
    return box.get(mangaId)?.cast<ListChapter>() ?? [];
  }

  void updateChapter(ListChapter chapter) {
    var box = Hive.box(chapterDao);
    var boxChapters = box.get((chapter.sId ?? ""))?.cast<ListChapter>() ?? [];
    var i = boxChapters.indexWhere((element) => element.sId == chapter.sId);
    if (i >= 0) {
      boxChapters[i] = chapter;
    } else {
      boxChapters.add(chapter);
    }
    boxChapters.sort((a, b) {
      return (a.index ?? 0) >= (b.index ?? 0) ? 1 : 0;
    });
    box.put((chapter.sId ?? ""), boxChapters);
  }
}
