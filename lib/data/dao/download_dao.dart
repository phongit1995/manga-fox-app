import 'package:hive/hive.dart';
import 'package:manga_fox_app/data/response/list_chapper_response.dart';

class DownloadDAO {
  final _download = "downloadImage";

  void add(List<String> path, String idChapter) {
    if(idChapter.isEmpty || path.isEmpty) return;
    var box = Hive.box(_download);
    box.put(idChapter, path);
  }

  List<String> getAll(String idChapter) {
    var box = Hive.box(_download);
    return box.get(_download)?.cast<String>() ?? [];
  }

  void delete(String idChapter) {
    var box = Hive.box(_download);
    box.delete(idChapter);
  }
}
