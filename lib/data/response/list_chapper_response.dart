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

class ListChapter {
  int? index;
  int? commentCount;
  List<String>? images;
  String? sId;
  String? name;
  String? url;
  String? createdAt;
  int? iV;
  String? after;
  String? before;
  bool? isRead;

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
}
