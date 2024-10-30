// To parse this JSON data, do
//
//     final postcommentresponse = postcommentresponseFromJson(jsonString);

import 'dart:convert';

Postcommentresponse postcommentresponseFromJson(String str) =>
    Postcommentresponse.fromJson(json.decode(str));

String postcommentresponseToJson(Postcommentresponse data) =>
    json.encode(data.toJson());

class Postcommentresponse {
  Postcommentresponse({
    this.success,
    this.comment,
  });

  bool? success;
  Comment? comment;

  factory Postcommentresponse.fromJson(Map<String, dynamic> json) =>
      Postcommentresponse(
        success: json["success"],
        comment: Comment.fromJson(json["comment"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "comment": comment!.toJson(),
      };
}

class Comment {
  Comment({
    this.id,
    this.comment,
    this.likes,
    this.reports,
    this.replies,
    this.postedBy,
  });

  String? id;
  String? comment;
  List<dynamic>? likes;
  List<dynamic>? reports;
  List<dynamic>? replies;
  PostedBy? postedBy;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["_id"],
        comment: json["comment"],
        likes: List<dynamic>.from(json["likes"].map((x) => x)),
        reports: List<dynamic>.from(json["reports"].map((x) => x)),
        replies: List<dynamic>.from(json["replies"].map((x) => x)),
        postedBy: PostedBy.fromJson(json["postedBy"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "comment": comment,
        "likes": List<dynamic>.from(likes!.map((x) => x)),
        "reports": List<dynamic>.from(reports!.map((x) => x)),
        "replies": List<dynamic>.from(replies!.map((x) => x)),
        "postedBy": postedBy!.toJson(),
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
