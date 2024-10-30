// To parse this JSON data, do
//
//     final commentreplyresponse = commentreplyresponseFromJson(jsonString);

import 'dart:convert';

Commentreplyresponse commentreplyresponseFromJson(String str) =>
    Commentreplyresponse.fromJson(json.decode(str));

String commentreplyresponseToJson(Commentreplyresponse data) =>
    json.encode(data.toJson());

class Commentreplyresponse {
  Commentreplyresponse({
    this.success,
    this.comment,
  });

  bool? success;
  Comment? comment;

  factory Commentreplyresponse.fromJson(Map<String, dynamic> json) =>
      Commentreplyresponse(
        success: json["success"],
        comment: Comment.fromJson(json["comment"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "comment": comment?.toJson(),
      };
}

class Comment {
  Comment({
    this.comment,
    this.likes,
    this.reports,
    this.replies,
    this.postedBy,
  });

  String? comment;
  List<dynamic>? likes;
  List<dynamic>? reports;
  List<Reply>? replies;
  PostedBy? postedBy;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        comment: json["comment"],
        likes: List<dynamic>.from(json["likes"].map((x) => x)),
        reports: List<dynamic>.from(json["reports"].map((x) => x)),
        replies:
            List<Reply>.from(json["replies"].map((x) => Reply.fromJson(x))),
        postedBy: PostedBy.fromJson(json["postedBy"]),
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "likes": List<dynamic>.from(likes!.map((x) => x)),
        "reports": List<dynamic>.from(reports!.map((x) => x)),
        "replies": List<dynamic>.from(replies!.map((x) => x.toJson())),
        "postedBy": postedBy?.toJson(),
      };
}

class PostedBy {
  PostedBy({
    this.type,
    this.username,
    this.firstname,
    this.lastname,
    this.userImage,
  });

  String? type;
  String? username;
  String? firstname;
  String? lastname;
  String? userImage;

  factory PostedBy.fromJson(Map<String, dynamic> json) => PostedBy(
        type: json["type"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        userImage: json["userImage"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "userImage": userImage,
      };
}

class Reply {
  Reply({
    this.id,
    this.comment,
    this.likes,
    this.reports,
    this.replies,
    this.postedBy,
    this.createdAt,
  });

  String? id;
  String? comment;
  List<dynamic>? likes;
  List<dynamic>? reports;
  List<dynamic>? replies;
  PostedBy? postedBy;
  DateTime? createdAt;

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        id: json["_id"],
        comment: json["comment"],
        likes: List<dynamic>.from(json["likes"].map((x) => x)),
        reports: List<dynamic>.from(json["reports"].map((x) => x)),
        replies: List<dynamic>.from(json["replies"].map((x) => x)),
        postedBy: PostedBy.fromJson(json["postedBy"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "comment": comment,
        "likes": List<dynamic>.from(likes!.map((x) => x)),
        "reports": List<dynamic>.from(reports!.map((x) => x)),
        "replies": List<dynamic>.from(replies!.map((x) => x)),
        "postedBy": postedBy?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
      };
}
