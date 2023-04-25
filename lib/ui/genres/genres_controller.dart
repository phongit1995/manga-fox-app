import 'package:flutter/material.dart';
import 'package:manga_reader_app/data/api_service.dart';
import 'package:manga_reader_app/data/response/manga_response.dart';

class GenresController {
  ValueNotifier<List<Manga>> mangas = ValueNotifier<List<Manga>>([]);
  ValueNotifier<String> genres = ValueNotifier<String>('');
  ValueNotifier<String> genresSelect = ValueNotifier<String>('');

  Future loadMangas(String category) async {
    var response = await ApiService.loadMangaCategoryResponse(category, numberItem: 500);
    genres.value = category;
    mangas.value = response?.data ?? [];
  }
}
