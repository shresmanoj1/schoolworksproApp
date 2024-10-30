import 'dart:convert';

Commentresponse commentresponseFromJson(String str) =>
    Commentresponse.fromJson(json.decode(str));

String commentresponseToJson(Commentresponse data) =>
    json.encode(data.toJson());

class Commentresponse {
  Commentresponse({
    this.success,
    this.comments,
  });

  bool? success;
  List<Comment>? comments;

  factory Commentresponse.fromJson(Map<String, dynamic> json) =>
      Commentresponse(
        success: json["success"],
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
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
    this.createdAt,
  });

  String? id;
  String? comment;
  List<String>? likes;
  List<dynamic>? reports;
  List<Comment>? replies;
  PostedBy? postedBy;
  DateTime? createdAt;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["_id"],
        comment: json["comment"],
        likes: List<String>.from(json["likes"].map((x) => x)),
        reports: List<dynamic>.from(json["reports"].map((x) => x)),
        replies:
            List<Comment>.from(json["replies"].map((x) => Comment.fromJson(x))),
        postedBy: PostedBy.fromJson(json["postedBy"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "comment": comment,
        "likes": List<dynamic>.from(likes!.map((x) => x)),
        "reports": List<dynamic>.from(reports!.map((x) => x)),
        "replies": List<dynamic>.from(replies!.map((x) => x.toJson())),
        "postedBy": postedBy!.toJson(),
        "createdAt": createdAt!.toIso8601String(),
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
