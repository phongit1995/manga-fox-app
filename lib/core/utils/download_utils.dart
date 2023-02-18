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
      await ImageGallerySaver.saveFile(savePath);
      print(savePath);
      return savePath;
    } on PlatformException catch (error) {
      Logger().e(error);
      return null;
    }
  }
}
