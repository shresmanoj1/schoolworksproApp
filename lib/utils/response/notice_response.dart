import 'dart:convert';

Noticeresponse noticeresponseFromJson(String str) =>
    Noticeresponse.fromJson(json.decode(str));

String noticeresponseToJson(Noticeresponse data) => json.encode(data.toJson());

class Noticeresponse {
  Noticeresponse({
    this.success,
    this.notices,
    this.unreadCount,
    this.totalNotices,
  });

  bool? success;
  List<Notice>? notices;
  int? unreadCount;
  int? totalNotices;

  factory Noticeresponse.fromJson(Map<String, dynamic> json) => Noticeresponse(
        success: json["success"],
        notices:
            List<Notice>.from(json["notices"].map((x) => Notice.fromJson(x))),
        unreadCount: json["unreadCount"],
        totalNotices: json["totalNotices"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "notices": List<dynamic>.from(notices!.map((x) => x.toJson())),
        "unreadCount": unreadCount,
        "totalNotices": totalNotices,
      };
}

class Notice {
  Notice({
    this.id,
    this.batch,
    this.readBy,
    this.noticeTitle,
    this.noticeContent,
    this.postedBy,
    this.createdAt,
    this.filename,
  });

  String? id;
  List<String>? batch;
  List<String>? readBy;
  String? noticeTitle;
  String? noticeContent;
  PostedBy? postedBy;
  DateTime? createdAt;
  String? filename;

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
        id: json["_id"],
        batch: List<String>.from(json["batch"].map((x) => x)),
        readBy: List<String>.from(json["readBy"].map((x) => x)),
        noticeTitle: json["noticeTitle"],
        noticeContent: json["noticeContent"],
        postedBy: PostedBy.fromJson(json["postedBy"]),
        createdAt: DateTime.parse(json["createdAt"]),
        filename: json["filename"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "batch": List<dynamic>.from(batch!.map((x) => x)),
        "readBy": List<dynamic>.from(readBy!.map((x) => x)),
        "noticeTitle": noticeTitle,
        "noticeContent": noticeContent,
        "postedBy": postedBy!.toJson(),
        "createdAt": createdAt!.toIso8601String(),
        "filename": filename,
      };
}

class PostedBy {
  PostedBy({
    this.firstname,
    this.lastname,
    this.userImage,
  });

  String? firstname;
  String? lastname;
  String? userImage;

  factory PostedBy.fromJson(Map<String, dynamic> json) => PostedBy(
        firstname: json["firstname"],
        lastname: json["lastname"],
        userImage: json["userImage"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "userImage": userImage,
      };
}
