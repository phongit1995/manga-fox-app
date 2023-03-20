import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'list_chapper_response.g.dart';

class ListChapterResponse {
  String? status;
  int? code;
  int? numberResult;
  List<ListChapter>? data;

  ListChapterResponse({this.status, this.code, this.numberResult, this.data});

  ListChapterResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    numberResult = json['numberResult'];
    if (json['data'] != null) {
      data = <ListChapter>[];
      json['data'].forEach((v) {
        data!.add(ListChapter.fromJson(v));
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

@HiveType(typeId: 1)
class ListChapter extends Equatable {
  @HiveField(0)
  int? index;
  @HiveField(1)
  int? commentCount;
  @HiveField(2)
  List<String>? images;
  @HiveField(3)
  String? sId;
  @HiveField(4)
  String? name;
  @HiveField(5)
  String? url;
  @HiveField(6)
  String? createdAt;
  @HiveField(7)
  int? iV;
  @HiveField(8)
  String? after;
  @HiveField(9)
  String? before;
  @HiveField(10)
  List<String>? imagesLocal;
  bool? isRead;
  int? indexPage;

  ListChapter(
      {this.index,
      this.commentCount,
      this.images,
      this.sId,
      this.name,
      this.url,
      this.createdAt,
      this.iV,
      this.after,
      this.before});

  ListChapter.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    commentCount = json['commentCount'];
    images = json['images'].cast<String>();
    sId = json['_id'];
    name = json['name'];
    url = json['url'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    after = json['after'];
    before = json['before'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['commentCount'] = commentCount;
    data['images'] = images;
    data['_id'] = sId;
    data['name'] = name;
    data['url'] = url;
    data['createdAt'] = createdAt;
    data['__v'] = iV;
    data['after'] = after;
    data['before'] = before;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [sId];
}
