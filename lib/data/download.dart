import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:manga_reader_app/data/response/list_chapper_response.dart';
import 'package:manga_reader_app/data/response/manga_response.dart';

class Download {

  ListChapter? chapter;
  Manga? manga;
  String? taskId;

  @override
  bool operator == (o) => o is Download && taskId == taskId;

  Download({
    this.chapter,
    this.manga,
    this.taskId
  });

  factory Download.fromJson(Map<String, dynamic> json) {
    return Download(
      chapter: ListChapter.fromJson(json['chapter']),
      manga: Manga.fromJson(json['manga']),
      taskId: json['taskId'],
    );
  }
  static void callback(String id, DownloadTaskStatus status, int progress) {}
  Map<String, dynamic> toMap() {
    return {
      'chapter': chapter!.toJson(),
      'manga': manga!.toJson(),
      'taskId': taskId,
    };
  }
  @override
  int get hashCode => taskId.hashCode;
}