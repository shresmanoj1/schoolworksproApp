// To parse this JSON data, do
//
//     final verifiedJournalresponse = verifiedJournalresponseFromJson(jsonString);

import 'dart:convert';

VerifiedJournalresponse verifiedJournalresponseFromJson(String str) => VerifiedJournalresponse.fromJson(json.decode(str));

String verifiedJournalresponseToJson(VerifiedJournalresponse data) => json.encode(data.toJson());

class VerifiedJournalresponse {
  VerifiedJournalresponse({
    this.success,
    this.journal,
  });

  bool ?success;
  List<Journal> ?journal;

  factory VerifiedJournalresponse.fromJson(Map<String, dynamic> json) => VerifiedJournalresponse(
    success: json["success"],
    journal: List<Journal>.from(json["journal"].map((x) => Journal.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "journal": List<dynamic>.from(journal!.map((x) => x.toJson())),
  };
}

class Journal {
  Journal({
    this.previewImage,
    this.verified,
    this.starsCount,
    this.title,
    this.intro,
    this.journalSlug,
    this.createdAt,
    this.author,
  });

  String ?previewImage;
  bool ?verified;
  int ?starsCount;
  String ?title;
  String ?intro;
  String ?journalSlug;
  DateTime ?createdAt;
  Author ?author;

  factory Journal.fromJson(Map<String, dynamic> json) => Journal(
    previewImage: json["preview_image"],
    verified: json["verified"],
    starsCount: json["stars_count"],
    title: json["title"],
    intro: json["intro"],
    journalSlug: json["journal_slug"],
    createdAt: DateTime.parse(json["createdAt"]),
    author: Author.fromJson(json["author"]),
  );

  Map<String, dynamic> toJson() => {
    "preview_image": previewImage,
    "verified": verified,
    "stars_count": starsCount,
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
