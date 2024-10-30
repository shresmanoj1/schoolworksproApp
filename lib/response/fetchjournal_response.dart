// To parse this JSON data, do
//
//     final fetchjournalresponse = fetchjournalresponseFromJson(jsonString);

// To parse this JSON data, do
//
//     final fetchjournalresponse = fetchjournalresponseFromJson(jsonString);

import 'dart:convert';

Fetchjournalresponse fetchjournalresponseFromJson(String str) => Fetchjournalresponse.fromJson(json.decode(str));

String fetchjournalresponseToJson(Fetchjournalresponse data) => json.encode(data.toJson());

class Fetchjournalresponse {
  Fetchjournalresponse({
    this.success,
    this.journal,
  });

  bool ?success;
  List<GetJournal> ?journal;

  factory Fetchjournalresponse.fromJson(Map<String, dynamic> json) => Fetchjournalresponse(
    success: json["success"],
    journal: List<GetJournal>.from(json["journal"].map((x) => GetJournal.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "journal": List<dynamic>.from(journal!.map((x) => x.toJson())),
  };
}

class GetJournal {
  GetJournal({
    this.previewImage,
    this.verified,
    this.starsCount,
    this.content,
    this.title,
    this.intro,
    this.journalSlug,
    this.createdAt,
    this.author,
  });

  String ?previewImage;
  bool ?verified;
  int ?starsCount;
  String ?content;
  String ?title;
  String ?intro;
  String ?journalSlug;
  DateTime ?createdAt;
  Author ?author;

  factory GetJournal.fromJson(Map<String, dynamic> json) => GetJournal(
    previewImage: json["preview_image"],
    verified: json["verified"],
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
    "verified": verified,
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


// import 'dart:convert';
//
// Fetchjournalresponse fetchjournalresponseFromJson(String str) => Fetchjournalresponse.fromJson(json.decode(str));
//
// String fetchjournalresponseToJson(Fetchjournalresponse data) => json.encode(data.toJson());
//
// class Fetchjournalresponse {
//   Fetchjournalresponse({
//     this.success,
//     this.journal,
//   });
//
//   bool ? success;
//   List<dynamic> ? journal;
//
//   factory Fetchjournalresponse.fromJson(Map<String, dynamic> json) => Fetchjournalresponse(
//     success: json["success"],
//     journal: List<dynamic>.from(json["journal"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "journal": List<dynamic>.from(journal!.map((x) => x)),
//   };
// }
//
// class Journal {
//   Journal({
//     this.previewImage,
//     this.verified,
//     this.starsCount,
//     this.content,
//     this.title,
//     this.intro,
//     this.journalSlug,
//     this.createdAt,
//     this.author,
//   });
//
//   String previewImage;
//   bool verified;
//   int starsCount;
//   String content;
//   String title;
//   String intro;
//   String journalSlug;
//   DateTime createdAt;
//   Author author;
//
//   factory Journal.fromJson(Map<String, dynamic> json) => Journal(
//     previewImage: json["preview_image"],
//     verified: json["verified"],
//     starsCount: json["stars_count"],
//     content: json["content"],
//     title: json["title"],
//     intro: json["intro"],
//     journalSlug: json["journal_slug"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     author: Author.fromJson(json["author"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "preview_image": previewImage,
//     "verified": verified,
//     "stars_count": starsCount,
//     "content": content,
//     "title": title,
//     "intro": intro,
//     "journal_slug": journalSlug,
//     "createdAt": createdAt.toIso8601String(),
//     "author": author.toJson(),
//   };
// }
//
// class Author {
//   Author({
//     this.firstname,
//     this.lastname,
//     this.userImage,
//   });
//
//   String firstname;
//   String lastname;
//   String userImage;
//
//   factory Author.fromJson(Map<String, dynamic> json) => Author(
//     firstname: json["firstname"],
//     lastname: json["lastname"],
//     userImage: json["userImage"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "firstname": firstname,
//     "lastname": lastname,
//     "userImage": userImage,
//   };
// }
