import 'package:flutter/material.dart';
import 'package:manga_reader_app/data/dao/manga_dao.dart';
import 'package:manga_reader_app/data/response/manga_response.dart';

class LibraryController {
  ValueNotifier<List<Manga>> mangaHistory = ValueNotifier<List<Manga>>([]);
  final MangaDAO mangaDao = MangaDAO();

  Future loadHistory() async{
    mangaHistory.value = await mangaDao.getMangaHistory();
  }

  static final LibraryController _singleton = LibraryController._internal();

  factory LibraryController() {
    return _singleton;
  }

  LibraryController._internal();
}
