// To parse this JSON data, do
//
//     final newsAnnouncementResponse = newsAnnouncementResponseFromJson(jsonString);

import 'dart:convert';

NewsAnnouncementResponse newsAnnouncementResponseFromJson(String str) =>
    NewsAnnouncementResponse.fromJson(json.decode(str));

String newsAnnouncementResponseToJson(NewsAnnouncementResponse data) =>
    json.encode(data.toJson());

class NewsAnnouncementResponse {
  NewsAnnouncementResponse({
    this.success,
    this.notices,
    this.unreadCount,
    this.totalNotices,
  });

  bool? success;
  List<Notice>? notices;
  int? unreadCount;
  int? totalNotices;

  factory NewsAnnouncementResponse.fromJson(Map<String, dynamic> json) =>
      NewsAnnouncementResponse(
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
    this.courseSlug,
    this.clubName,
    this.readBy,
    this.noticeTitle,
    this.noticeContent,
    this.type,
    this.postedBy,
    this.createdAt,
    this.filename,
  });

  String? id;
  List<String>? batch;
  List<String>? courseSlug;
  List<dynamic>? clubName;
  List<String>? readBy;
  String? noticeTitle;
  String? noticeContent;
  String? type;
  PostedBy? postedBy;
  DateTime? createdAt;
  String? filename;

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
        id: json["_id"],
        batch: List<String>.from(json["batch"].map((x) => x)),
        courseSlug: List<String>.from(json["courseSlug"].map((x) => x)),
        clubName: List<dynamic>.from(json["clubName"].map((x) => x)),
        readBy: List<String>.from(json["readBy"].map((x) => x)),
        noticeTitle: json["noticeTitle"],
        noticeContent: json["noticeContent"],
        type: json["type"],
        postedBy: PostedBy.fromJson(json["postedBy"]),
        createdAt: DateTime.parse(json["createdAt"]),
        filename: json["filename"] == null ? null : json["filename"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "batch": List<dynamic>.from(batch!.map((x) => x)),
        "courseSlug": List<dynamic>.from(courseSlug!.map((x) => x)),
        "clubName": List<dynamic>.from(clubName!.map((x) => x)),
        "readBy": List<dynamic>.from(readBy!.map((x) => x)),
        "noticeTitle": noticeTitle,
        "noticeContent": noticeContent,
        "type": type,
        "postedBy": postedBy?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "filename": filename == null ? null : filename,
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
        userImage: json["userImage"] == null ? null : json["userImage"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "userImage": userImage == null ? null : userImage,
      };
}
