import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

part 'manga_response.g.dart';

class MangaResponse {
  String? status;
  int? code;
  List<Manga>? data;

  MangaResponse({this.status, this.code, this.data});

  MangaResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <Manga>[];
      json['data'].forEach((v) {
        data!.add(Manga.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 0)
class Manga extends Equatable {
  @HiveField(0)
  List<String>? category;
  @HiveField(1)
  int? views;
  @HiveField(2)
  int? mangaStatus;
  @HiveField(3)
  int? chapterUpdateCount;
  @HiveField(4)
  bool? enable;
  @HiveField(5)
  bool? crawled;
  @HiveField(6)
  int? commentCount;
  @HiveField(7)
  String? sId;
  @HiveField(8)
  String? name;
  @HiveField(9)
  String? url;
  @HiveField(10)
  String? chapterUpdate;
  @HiveField(11)
  String? createdAt;
  @HiveField(12)
  String? updatedAt;
  @HiveField(13)
  int? iV;
  @HiveField(14)
  String? author;
  @HiveField(15)
  String? description;
  FirstChapter? firstChapter;
  @HiveField(16)
  String? image;
  @HiveField(17)
  String? imageLocal;
  String? lastChapter;
  @HiveField(18)
  num? startRate;

  bool isRead = false;
  bool isDownload = false;

  String mapView() {
    var number = views ?? 0;
    String formattedNumber;

    if (number >= 1000000000) {
      formattedNumber = "${(number / 1000000000).toStringAsFixed(12)}B";
    } else if (number >= 1000000) {
      formattedNumber = "${(number / 1000000).toStringAsFixed(2)}M";
    } else if (number >= 1000) {
      formattedNumber = "${(number / 1000).toStringAsFixed(2)}K";
    } else {
      formattedNumber = number.toStringAsFixed(0);
    }
    return formattedNumber;
  }

  String mapStatus() {
    return mangaStatus == 0 ? "Continue" : "Done";
  }

  String mapRate() {
    return startRate == null ? "4.0" : "$startRate";
  }

  Manga(
      {this.category,
      this.views,
      this.mangaStatus,
      this.chapterUpdateCount,
      this.enable,
      this.crawled,
      this.commentCount,
      this.sId,
      this.name,
      this.url,
      this.chapterUpdate,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.author,
      this.description,
      this.firstChapter,
      this.image,
      this.startRate,
      this.lastChapter});

  Manga.fromJson(Map<String, dynamic> json) {
    Logger().e(json);
    category = json['category']?.cast<String>() ?? [];
    views = json['views'];
    mangaStatus = json['manga_status'];
    chapterUpdateCount = json['chapter_update_count'];
    enable = json['enable'];
    crawled = json['crawled'];
    commentCount = json['commentCount'];
    sId = json['_id'];
    name = json['name'];
    url = json['url'];
    // startRate = json['startRate'];
    chapterUpdate = json['chapter_update'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    author = json['author'];
    description = json['description'];
    firstChapter = json['first_chapter'] != null
        ? FirstChapter.fromJson(json['first_chapter'])
        : null;
    image = json['image'];
    lastChapter = json['last_chapter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['views'] = views;
    data['manga_status'] = mangaStatus;
    data['chapter_update_count'] = chapterUpdateCount;
    data['enable'] = enable;
    data['crawled'] = crawled;
    data['commentCount'] = commentCount;
    data['_id'] = sId;
    data['name'] = name;
    data['url'] = url;
    data['chapter_update'] = chapterUpdate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['author'] = author;
    data['startRate'] = startRate;
    data['description'] = description;
    if (firstChapter != null) {
      data['first_chapter'] = firstChapter!.toJson();
    }
    data['image'] = image;
    data['last_chapter'] = lastChapter;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [sId];
}

class FirstChapter {
  String? sId;
  String? url;

  FirstChapter({this.sId, this.url});

  FirstChapter.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['url'] = url;
    return data;
  }
}
