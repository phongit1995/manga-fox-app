import 'package:hive/hive.dart';
import 'package:manga_reader_app/data/response/manga_response.dart';

class MangaDAO {
  static const mangaHistory = "mangaHistory";
  static const mangaDownload = "mangaDownload";
  static const mangaFavorite = "mangaFavorite";
  static const manga = "manga";

  static init() async {
    await Hive.openBox(manga);
  }

  List<Manga> getMangaFavorite() {
    var box = Hive.box(manga);
    return box.get(mangaFavorite)?.cast<Manga>() ?? [];
  }

  void addMangaFavorite(Manga m) {
    var box = Hive.box(manga);
    List<Manga> rs = [];
    var rsBox = box.get(mangaFavorite);
    if (rsBox != null) {
      rs.addAll(rsBox.cast<Manga>());
    } else {
      rs.add(m);
      box.put(mangaFavorite, rs);
    }
    var i = rs.indexWhere((element) => element.sId == m.sId);
    if (i >= 0) {
      rs.removeAt(i);
    }
    rs.add(m);

    box.put(mangaFavorite, rs);
  }

  void deleteMangaFavorite(Manga m) {
    var box = Hive.box(manga);
    var boxMangas = box.get(mangaFavorite)?.cast<Manga>() ?? [];
    var i = boxMangas.indexWhere((element) => element.sId == m.sId);
    if (i >= 0) {
      boxMangas.removeAt(i);
    }
    box.put(mangaFavorite, boxMangas);
  }

  List<Manga> getMangaDownload() {
    var box = Hive.box(manga);
    return box.get(mangaDownload)?.cast<Manga>() ?? [];
  }

  void addMangaDownload(Manga m) {
    var box = Hive.box(manga);
    List<Manga> rs = [];
    var rsBox = box.get(mangaDownload);
    if (rsBox != null) {
      rs.addAll(rsBox.cast<Manga>());
    } else {
      rs.add(m);
      box.put(mangaDownload, rs);
    }
    var i = rs.indexWhere((element) => element.sId == m.sId);
    if (i >= 0) {
      rs.removeAt(i);
    }
    rs.add(m);

    box.put(mangaDownload, rs);
  }

  void deleteMangaDownload(Manga m) {
    var box = Hive.box(manga);
    var boxMangas = box.get(mangaDownload)?.cast<Manga>() ?? [];
    var i = boxMangas.indexWhere((element) => element.sId == m.sId);
    if (i >= 0) {
      boxMangas.removeAt(i);
    }
    box.put(mangaDownload, boxMangas);
  }

  List<Manga> getMangaHistory() {
    var box = Hive.box(manga);
    return box.get(mangaHistory)?.cast<Manga>() ?? [];
  }

  void addMangaHistory(Manga m) {
    var box = Hive.box(manga);
    List<Manga> rs = [];
    var rsBox = box.get(mangaHistory);
    if (rsBox != null) {
      rs.addAll(rsBox.cast<Manga>());
    } else {
      rs.add(m);
      box.put(mangaHistory, rs);
    }
    var i = rs.indexWhere((element) => element.sId == m.sId);
    if (i >= 0) {
      rs.removeAt(i);
    }
    rs.add(m);

    box.put(mangaHistory, rs);
  }

  void deleteMangaHistory(Manga m) {
    var box = Hive.box(manga);
    var boxMangas = box.get(mangaHistory)?.cast<Manga>() ?? [];
    var i = boxMangas.indexWhere((element) => element.sId == m.sId);
    if (i >= 0) {
      boxMangas.removeAt(i);
    }
    box.put(mangaHistory, boxMangas);
  }
}
