import 'dart:math';

class NovelResponse {
  String? status;
  int? code;
  List<Novel>? data;

  NovelResponse({this.status, this.code, this.data});

  NovelResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <Novel>[];
      json['data'].forEach((v) {
        data!.add(Novel.fromJson(v));
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

class Novel {
  List<String>? category;
  int? views;
  int? mangaStatus;
  int? chapterUpdateCount;
  bool? enable;
  int? commentCount;
  List<String>? devices;
  String? sId;
  bool? crawler;
  String? url;
  String? chapterUpdate;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? author;
  String? description;
  String? firstChapter;
  String? image;
  String? lastChapter;
  String? name;
  double? rate;

  Novel(
      {this.category,
        this.views,
        this.mangaStatus,
        this.chapterUpdateCount,
        this.enable,
        this.commentCount,
        this.devices,
        this.sId,
        this.crawler,
        this.url,
        this.chapterUpdate,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.author,
        this.description,
        this.firstChapter,
        this.image,
        this.lastChapter,
        this.name});

  Novel.fromJson(Map<String, dynamic> json) {
    category = json['category'].cast<String>();
    views = json['views'];
    mangaStatus = json['manga_status'];
    chapterUpdateCount = json['chapter_update_count'];
    enable = json['enable'];
    commentCount = json['commentCount'];
    rate = doubleInRange(Random(),3.5,4);
    // if (json['devices'] != null) {
    //   devices = <Null>[];
    //   json['devices'].forEach((v) {
    //     devices!.add(new Null.fromJson(v));
    //   });
    // }
    sId = json['_id'];
    crawler = json['crawler'];
    url = json['url'];
    chapterUpdate = json['chapter_update'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    author = json['author'];
    description = json['description'];
    firstChapter = json['first_chapter'];
    image = json['image'];
    lastChapter = json['last_chapter'];
    name = json['name'];
  }

  String mapStatus() {
    return (mangaStatus == 0 ? "Continue" : "Done").toUpperCase();
  }

  String mapRate() {
    return rate?.toStringAsFixed(1) ?? '4.0';
  }

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

  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['views'] = views;
    data['manga_status'] = mangaStatus;
    data['chapter_update_count'] = chapterUpdateCount;
    data['enable'] = enable;
    data['commentCount'] = commentCount;
    // if (this.devices != null) {
    //   data['devices'] = this.devices!.map((v) => v.toJson()).toList();
    // }
    data['_id'] = sId;
    data['crawler'] = crawler;
    data['url'] = url;
    data['chapter_update'] = chapterUpdate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['author'] = author;
    data['description'] = description;
    data['first_chapter'] = firstChapter;
    data['image'] = image;
    data['last_chapter'] = lastChapter;
    data['name'] = name;
    return data;
  }
}
