import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class DownloadUtils {
  static List<String> task = [];
  static Future<String?> downloadImage(
    String url, {
    AndroidDestinationType? destination,
    bool whenError = false,
    String? outputMimeType,
  }) async {
    try {
      var appDocDir = await getTemporaryDirectory();
      String savePath =
          "${appDocDir.path}/${url.replaceAll("/", "_").replaceAll(":", "_")}";
      await Dio().download(url, savePath,
          options: Options(headers: {"Referer": "https://manganelo.com/"}));
      // await ImageGallerySaver.saveFile(savePath.replaceAll(".jpg", ""));
      return savePath;
    } on PlatformException catch (error) {
      return null;
    }
  }

  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if(appDir.existsSync()){
      appDir.deleteSync(recursive: true);
    }
  }
}
