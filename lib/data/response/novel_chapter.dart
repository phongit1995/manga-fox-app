import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
part 'novel_chapter.g.dart';

class NovelChapterResponse {
  String? status;
  int? code;
  int? numberResult;
  List<NovelChapter>? data;

  NovelChapterResponse({this.status, this.code, this.numberResult, this.data});

  NovelChapterResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    numberResult = json['numberResult'];
    if (json['data'] != null) {
      data = <NovelChapter>[];
      json['data'].forEach((v) {
        data!.add(NovelChapter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['numberResult'] = numberResult;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 4)
class NovelChapter extends Equatable{
  @HiveField(0)
  int? index;
  @HiveField(1)
  int? commentCount;
  @HiveField(2)
  String? sId;
  @HiveField(3)
  String? manga;
  @HiveField(4)
  String? title;
  @HiveField(5)
  String? createdAt;
  @HiveField(6)
  int? iV;
  String? content;
  bool? isRead;
  int? indexPage;

  String get getDateCreates {
    String dateTime = createdAt ?? '';
    if (dateTime.isEmpty) return '';
    DateTime parsedDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(dateTime).toLocal();

    return DateFormat.yMd().add_jm().format(parsedDateFormat).toString();
  }

  NovelChapter(
      {this.index,
        this.commentCount,
        this.sId,
        this.manga,
        this.title,
        this.createdAt,
        this.content,
        this.iV});

  NovelChapter.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    commentCount = json['commentCount'];
    sId = json['_id'];
    manga = json['manga'];
    title = json['title'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['commentCount'] = commentCount;
    data['_id'] = sId;
    data['manga'] = manga;
    data['title'] = title;
    data['createdAt'] = createdAt;
    data['__v'] = iV;
    data['content'] = content;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [sId];
}
