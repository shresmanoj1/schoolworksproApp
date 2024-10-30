// To parse this JSON data, do
//
//     final issuebookrequest = issuebookrequestFromJson(jsonString);

import 'dart:convert';

Issuebookrequest issuebookrequestFromJson(String str) => Issuebookrequest.fromJson(json.decode(str));

String issuebookrequestToJson(Issuebookrequest data) => json.encode(data.toJson());

class Issuebookrequest {
  Issuebookrequest({
    this.bookSlug,
    this.username,
  });

  String ? bookSlug;
  String ? username;

  factory Issuebookrequest.fromJson(Map<String, dynamic> json) => Issuebookrequest(
    bookSlug: json["book_slug"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "book_slug": bookSlug,
    "username": username,
  };
}
