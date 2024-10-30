// To parse this JSON data, do
//
//     final weeklyDetailsresponse = weeklyDetailsresponseFromJson(jsonString);

import 'dart:convert';

WeeklyDetailsresponse weeklyDetailsresponseFromJson(String str) => WeeklyDetailsresponse.fromJson(json.decode(str));

String weeklyDetailsresponseToJson(WeeklyDetailsresponse data) => json.encode(data.toJson());

class WeeklyDetailsresponse {
  WeeklyDetailsresponse({
    this.success,
    this.journal,
  });

  bool ?success;
  JournalDetail ?journal;

  factory WeeklyDetailsresponse.fromJson(Map<String, dynamic> json) => WeeklyDetailsresponse(
    success: json["success"],
    journal: JournalDetail.fromJson(json["journal"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "journal": journal?.toJson(),
  };
}

class JournalDetail {
  JournalDetail({
    this.previewImage,
    this.stars,
    this.comments,
    this.starsCount,
    this.content,
    this.title,
    this.intro,
    this.journalSlug,
    this.createdAt,
    this.author,
  });

  String ?previewImage;
  List<String> ?stars;
  List<Comment> ?comments;
  int ?starsCount;
  String ?content;
  String ?title;
  String ?intro;
  String ?journalSlug;
  DateTime ?createdAt;
  Author ?author;

  factory JournalDetail.fromJson(Map<String, dynamic> json) => JournalDetail(
    previewImage: json["preview_image"],
    stars: List<String>.from(json["stars"].map((x) => x)),
    comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    starsCount: json["stars_count"],
    content: json["content"],
    title: json["title"],
    intro: json["intro"],
    journalSlug: json["journal_slug"],
    createdAt: DateTime.parse(json["createdAt"]),
    author: Author.fromJson(json["author"]),
  );

  Map<String, dynamic> toJson() => {
    "preview_image": previewImage,
    "stars": List<dynamic>.from(stars!.map((x) => x)),
    "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
    "stars_count": starsCount,
    "content": content,
    "title": title,
    "intro": intro,
    "journal_slug": journalSlug,
    "createdAt": createdAt?.toIso8601String(),
    "author": author?.toJson(),
  };
}

class Author {
  Author({
    this.firstname,
    this.lastname,
    this.userImage,
  });

  String ?firstname;
  String ?lastname;
  String ?userImage;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
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

class Comment {
  Comment({
    this.comment,
    this.postedBy,
    this.createdAt,
  });

  String ?comment;
  Author ?postedBy;
  DateTime ?createdAt;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    comment: json["comment"],
    postedBy: Author.fromJson(json["postedBy"]),
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "comment": comment,
    "postedBy": postedBy?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
  };
}
