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
      // var response = await dio.get("category/get-list");
      final json = {
        "status": "success",
        "code": 200,
        "data": [
          {
            "enable": true,
            "_id": "62622f079909f721220170ff",
            "name": "Action",
            "image": "https://avatar.novelonlinefree.com/avatar_novels/5278-zhan_long.jpg",
            "createdAt": "2022-04-22T04:28:55.125Z",
            "updatedAt": "2022-06-29T08:56:46.968Z",
            "__v": 0
          },
          {
            "enable": true,
            "_id": "62622f349909f72122017100",
            "name": "Adventure",
            "image": "https://avatar.novelonlinefree.com/avatar_novels/34214-1608770539.jpg",
            "createdAt": "2022-04-22T04:29:40.584Z",
            "updatedAt": "2022-06-29T08:56:46.968Z",
            "__v": 0
          },
          {
            "enable": true,
            "_id": "62622f5a9909f72122017101",
            "name": "Drama",
            "image": "https://avatar.novelonlinefree.com/avatar_novels/26951-1581961609.jpg",
            "createdAt": "2022-04-22T04:30:18.883Z",
            "updatedAt": "2022-06-29T08:56:46.968Z",
            "__v": 0
          },
          {
            "enable": true,
            "_id": "62622f9c9909f72122017102",
            "name": "Fantasy",
            "image": "https://avatar.novelonlinefree.com/avatar_novels/33875-1607588157.jpg",
            "createdAt": "2022-04-22T04:31:24.733Z",
            "updatedAt": "2022-06-29T08:56:46.968Z",
            "__v": 0
          },
          {
            "enable": true,
            "_id": "629d64c82b1a6c6b3be77434",
            "name": "Comedy",
            "image": "https://avatar.novelonlinefree.com/avatar_novels/33871-1607587967.jpg",
            "createdAt": "2022-06-06T02:22:00.610Z",
            "updatedAt": "2022-06-29T08:56:46.968Z",
            "__v": 0
          },
          {
            "enable": true,
            "_id": "629d65572b1a6c6b3be77437",
            "name": "Fantasy",
            "image": "https://avatar.novelonlinefree.com/avatar_novels/26532-1580291502.jpg",
            "createdAt": "2022-06-06T02:24:23.520Z",
            "updatedAt": "2022-06-29T08:56:46.968Z",
            "__v": 0
          },
          {
            "enable": true,
            "_id": "629d65822b1a6c6b3be77438",
            "name": "Historical",
            "image": "https://avatar.novelonlinefree.com/avatar_novels/36555-unparalleled_after_ten_consecutive_draws.jpg",
            "createdAt": "2022-06-06T02:25:06.228Z",
            "updatedAt": "2022-06-29T08:56:46.968Z",
            "__v": 0
          },
          {
            "enable": true,
            "_id": "629d65df2b1a6c6b3be77439",
            "name": "Horror",
            "image": "https://avatar.novelonlinefree.com/avatar_novels/37708-1653715776.jpg",
            "createdAt": "2022-06-06T02:26:39.401Z",
            "updatedAt": "2022-06-29T08:56:46.968Z",
            "__v": 0
          },
          {
            "enable": true,
            "_id": "629d66872b1a6c6b3be7743d",
            "name": "Mature",
            "image": "https://avatar.novelonlinefree.com/avatar_novels/37441-1652171006.jpg",
            "createdAt": "2022-06-06T02:29:27.761Z",
            "updatedAt": "2022-06-29T08:56:46.968Z",
            "__v": 0
          },
          {
            "enable": true,
            "_id": "629d67052b1a6c6b3be77442",
            "name": "Romance",
            "image": "https://avatar.novelonlinefree.com/avatar_novels/26335-1579622694.jpg",
            "createdAt": "2022-06-06T02:31:33.108Z",
            "updatedAt": "2022-06-29T08:56:46.968Z",
            "__v": 0
          },
          {
            "enable": true,
            "_id": "629d681d2b1a6c6b3be7744b",
            "name": "Sports",
            "image": "https://res.cloudinary.com/no-company-name/image/upload/v1656492689/novel/34299-1608913707_baybsu.png",
            "createdAt": "2022-06-06T02:36:13.931Z",
            "updatedAt": "2022-06-29T08:56:46.968Z",
            "__v": 0
          },
          {
            "enable": true,
            "_id": "629d68982b1a6c6b3be7744d",
            "name": "Tragedy",
            "image": "https://avatar.novelonlinefree.com/avatar_novels/34305-1608914193.jpg",
            "createdAt": "2022-06-06T02:38:16.065Z",
            "updatedAt": "2022-06-29T08:56:46.968Z",
            "__v": 0
          }
        ]
      };
      return GenerateResponse.fromJson(json);
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
      {int page = 1,int numberItem = 100}) async {
    try {
      print("loadMangaCategoryResponse $category");
      var response = await dio.post("manga/suggest-manga", data: {
        "category": [category],
        "page": page,
        "numberItem": numberItem,
        "type_sort": 1
      });
      print(NovelResponse.fromJson(response.data)?.data?.length);
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
