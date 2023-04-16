import 'package:hive/hive.dart';
import 'package:manga_fox_app/data/response/novel_chapter.dart';

class ChapterNovelDAO {
  final chapterDaoNovel = "chapter_novel";
  final chapterReadingDaoNovel = "chapterReadingDao_novel";
  final chapterPercentReadingDaoNovel = "chapterPercentReadingDao_novel";

  void addPercentChapterReading(String chapterId, double p) {
    if(chapterId.isEmpty) return;
    var box = Hive.box(chapterPercentReadingDaoNovel);
    box.put(chapterId, p);
  }

  double? getPercentChapterReading(String chapterId) {
    var box = Hive.box(chapterPercentReadingDaoNovel);
    return double.tryParse(box.get(chapterId)?.toString() ?? '0');
  }

  void addReading(String chapterId, String mangaId) {
    if(chapterId.isEmpty || mangaId.isEmpty) return;
    var box = Hive.box(chapterReadingDaoNovel);
    box.put(mangaId, chapterId);
  }

  String? getReading(String mangaId) {
    var box = Hive.box(chapterReadingDaoNovel);
    return box.get(mangaId)?.toString();
  }


  void addListChapter(List<NovelChapter> chapter, String mangaId) {
    if(mangaId.isEmpty || chapter.isEmpty) return;
    var box = Hive.box(chapterDaoNovel);
    box.put(mangaId, chapter);
  }

  List<NovelChapter> getListChapter(String mangaId) {
    var box = Hive.box(chapterDaoNovel);
    return box.get(mangaId)?.cast<NovelChapter>() ?? [];
  }

  void updateChapter(NovelChapter chapter) {
    var box = Hive.box(chapterDaoNovel);
    var boxChapters = box.get((chapter.sId ?? ""))?.cast<NovelChapter>() ?? [];
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
