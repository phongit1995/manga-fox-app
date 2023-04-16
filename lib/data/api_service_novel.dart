import 'package:dio/dio.dart';
import 'package:manga_fox_app/app_config.dart';
import 'package:manga_fox_app/core/utils/setting_utils.dart';
import 'package:manga_fox_app/data/response/generate_response.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';
import 'package:manga_fox_app/data/response/novel_chapter.dart';
import 'package:manga_fox_app/data/response/novel_response.dart';

class ApiServiceNovel {
  final baseUrl = "";
  static Dio dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseApiUrlNovel,
      contentType: Headers.jsonContentType,
      headers: {
        "appCreatedTime":
            SettingUtils.timeInitApp ?? DateTime.now().millisecondsSinceEpoch
      }
      // connectTimeout: 50000,
      // sendTimeout: 50000,
      // receiveTimeout: 50000,
      ));

  static Future<GenerateResponse?> loadGenerateResponse() async {
    try {
      var response = await dio.get("category/get-list");
      return GenerateResponse.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  static Future<MangaResponse?> searchMangaResponse(String name) async {
    try {
      var response = await dio.post("manga/search-manga",
          data: {"page": 1, "numberItem": 100, "name": name});
      return MangaResponse.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  static Future<MangaResponse?> loadMangaResponse(int type) async {
    try {
      var response = await dio.post("manga/get-list",
          data: {"page": 1, "numberItem": 20, "type": type});
      return MangaResponse.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  static Future<NovelChapterResponse?> loadMangaListChapterResponse(
      idManga) async {
    try {
      var response = await dio.post("chapter/list-chapter", data: {
        "manga_id": idManga,
        "page": 1,
        "numberItem": 3000,
        "sort": 1
      });
      return NovelChapterResponse.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  static Future<NovelResponse?> loadMangaCategoryResponse(String category,
      {int numberItem = 100}) async {
    try {
      var response = await dio.post("manga/suggest-manga", data: {
        "category": [category],
        "page": 1,
        "numberItem": numberItem,
        "type_sort": 1
      });
      return NovelResponse.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  static Future<MangaResponse?> loadMangaExclusivelyResponse({
    List<String>? category,
    int numberItem = 20,
  }) async {
    try {
      var response = await dio.post("manga/suggest-manga", data: {
        "category": [
          "Action",
          "Adventure",
          "Comedy",
          "Drama",
          "Fantasy",
          "Shounen"
        ],
        "page": 1,
        "numberItem": numberItem,
        "type_sort": 1
      });
      return MangaResponse.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  static Future<NovelChapter?> detailChapter(String chapterId) async {
    try {
      var response =
          await dio.post("chapter/detial-chapter", data: {"id": chapterId});
      return NovelChapter.fromJson(response.data['data']);
    } catch (e) {
      return null;
    }
  }
}
