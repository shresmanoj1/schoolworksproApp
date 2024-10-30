// To parse this JSON data, do
//
//     final likereponse = likereponseFromJson(jsonString);

import 'dart:convert';

Likereponse likereponseFromJson(String str) =>
    Likereponse.fromJson(json.decode(str));

String likereponseToJson(Likereponse data) => json.encode(data.toJson());

class Likereponse {
  Likereponse({
    this.success,
    this.comment,
  });

  bool? success;
  Comment? comment;

  factory Likereponse.fromJson(Map<String, dynamic> json) => Likereponse(
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
  List<String>? likes;
  List<dynamic>? reports;
  List<dynamic>? replies;
  PostedBy? postedBy;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["_id"],
        comment: json["comment"],
        likes: List<String>.from(json["likes"].map((x) => x)),
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
    this.firstname,
    this.lastname,
    this.userImage,
  });

  String? type;
  String? firstname;
  String? lastname;
  String? userImage;

  factory PostedBy.fromJson(Map<String, dynamic> json) => PostedBy(
        type: json["type"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        userImage: json["userImage"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "firstname": firstname,
        "lastname": lastname,
        "userImage": userImage,
      };
}
