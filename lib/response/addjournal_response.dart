// To parse this JSON data, do
//
//     final addJournalresponse = addJournalresponseFromJson(jsonString);

import 'dart:convert';

AddJournalresponse addJournalresponseFromJson(String str) => AddJournalresponse.fromJson(json.decode(str));

String addJournalresponseToJson(AddJournalresponse data) => json.encode(data.toJson());

class AddJournalresponse {
  AddJournalresponse({
    this.success,
    this.message,
    this.journal,
    this.file,
  });

  bool ?success;
  String ?message;
  Journal ?journal;
  String ?file;

  factory AddJournalresponse.fromJson(Map<String, dynamic> json) => AddJournalresponse(
    success: json["success"],
    message: json["message"],
    journal: Journal.fromJson(json["journal"]),
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "journal": journal!.toJson(),
    "file": file,
  };
}

class Journal {
  Journal({
    this.previewImage,
    this.verified,
    this.softDelete,
    this.stars,
    this.comments,
    this.starsCount,
    this.history,
    this.content,
    this.title,
    this.postedBy,
    this.intro,
    this.institution,
    this.journalSlug,
    this.createdAt,
  });

  String ?previewImage;
  bool ?verified;
  bool ?softDelete;
  List<dynamic> ?stars;
  List<dynamic> ?comments;
  int ?starsCount;
  List<dynamic> ?history;
  String ?content;
  String ?title;
  String ?postedBy;
  String ?intro;
  String ?institution;
  String ?journalSlug;
  DateTime ?createdAt;

  factory Journal.fromJson(Map<String, dynamic> json) => Journal(
    previewImage: json["preview_image"],
    verified: json["verified"],
    softDelete: json["soft_delete"],
    stars: List<dynamic>.from(json["stars"].map((x) => x)),
    comments: List<dynamic>.from(json["comments"].map((x) => x)),
    starsCount: json["stars_count"],
    history: List<dynamic>.from(json["history"].map((x) => x)),
    content: json["content"],
    title: json["title"],
    postedBy: json["postedBy"],
    intro: json["intro"],
    institution: json["institution"],
    journalSlug: json["journal_slug"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "preview_image": previewImage,
    "verified": verified,
    "soft_delete": softDelete,
    "stars": List<dynamic>.from(stars!.map((x) => x)),
    "comments": List<dynamic>.from(comments!.map((x) => x)),
    "stars_count": starsCount,
    "history": List<dynamic>.from(history!.map((x) => x)),
    "content": content,
    "title": title,
    "postedBy": postedBy,
    "intro": intro,
    "institution": institution,
    "journal_slug": journalSlug,
    "createdAt": createdAt?.toIso8601String(),
  };
}
