// To parse this JSON data, do
//
//     final galleryresponse = galleryresponseFromJson(jsonString);

import 'dart:convert';

Galleryresponse galleryresponseFromJson(String str) => Galleryresponse.fromJson(json.decode(str));

String galleryresponseToJson(Galleryresponse data) => json.encode(data.toJson());

class Galleryresponse {
  Galleryresponse({
    this.success,
    this.galleries,
  });

  bool ? success;
  List<Gallery> ? galleries;

  factory Galleryresponse.fromJson(Map<String, dynamic> json) => Galleryresponse(
    success: json["success"],
    galleries: List<Gallery>.from(json["galleries"].map((x) => Gallery.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "galleries": List<dynamic>.from(galleries!.map((x) => x.toJson())),
  };
}

class Gallery {
  Gallery({
    this.media,
    this.id,
    this.title,
    this.description,
    this.institution,
    this.postedBy,
    this.createdAt,
    this.updatedAt,
    this.slug
  });

  List<String> ? media;
  String ? id;
  String ? title;
  String ? description;
  String ? institution;
  String ? slug;
  String ? postedBy;
  DateTime ? createdAt;
  DateTime ? updatedAt;

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
    media: List<String>.from(json["media"].map((x) => x)),
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    institution: json["institution"],
    slug: json["slug"],
    postedBy: json["postedBy"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "media": List<dynamic>.from(media!.map((x) => x)),
    "_id": id,
    "title": title,
    "description": description,
    "institution": institution,
    "postedBy": postedBy,
    "slug":slug,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
