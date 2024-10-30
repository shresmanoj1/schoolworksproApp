// To parse this JSON data, do
//
//     final digitalBookMarkedResponse = digitalBookMarkedResponseFromJson(jsonString);

import 'dart:convert';

DigitalBookMarkedResponse digitalBookMarkedResponseFromJson(String str) => DigitalBookMarkedResponse.fromJson(json.decode(str));

String digitalBookMarkedResponseToJson(DigitalBookMarkedResponse data) => json.encode(data.toJson());

class DigitalBookMarkedResponse {
  DigitalBookMarkedResponse({
    this.success,
    this.bookmarks,
  });

  bool? success;
  List<Bookmark>? bookmarks;

  factory DigitalBookMarkedResponse.fromJson(Map<String, dynamic> json) => DigitalBookMarkedResponse(
    success: json["success"],
    bookmarks: List<Bookmark>.from(json["bookmarks"].map((x) => Bookmark.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "bookmarks": List<dynamic>.from(bookmarks!.map((x) => x.toJson())),
  };
}

class Bookmark {
  Bookmark({
    this.id,
    this.username,
    this.bookId,
    this.pageNumber,
    this.institution,
    this.createdAt,
  });

  String? id;
  String? username;
  BookId? bookId;
  dynamic pageNumber;
  String? institution;
  DateTime? createdAt;

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
    id: json["_id"],
    username: json["username"],
    bookId: BookId.fromJson(json["book_id"]),
    pageNumber: json["pageNumber"],
    institution: json["institution"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "book_id": bookId?.toJson(),
    "pageNumber": pageNumber,
    "institution": institution,
    "createdAt": createdAt?.toIso8601String(),
  };
}

class BookId {
  BookId({
    this.softDelete,
    this.institution,
    this.id,
    this.size,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.slug,
    this.file,
    this.category,
    this.name,
  });

  bool? softDelete;
  List<String>? institution;
  String? id;
  String? size;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? v;
  String? slug;
  String? file;
  Category? category;
  String? name;

  factory BookId.fromJson(Map<String, dynamic> json) => BookId(
    softDelete: json["soft_delete"],
    institution: List<String>.from(json["institution"].map((x) => x)),
    id: json["_id"],
    size: json["size"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    slug: json["slug"],
    file: json["file"],
    category: Category.fromJson(json["category"]),
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "soft_delete": softDelete,
    "institution": List<dynamic>.from(institution!.map((x) => x)),
    "_id": id,
    "size": size,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "slug": slug,
    "file": file,
    "category": category?.toJson(),
    "name": name,
  };
}

class Category {
  Category({
    this.institution,
    this.softDelete,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.name,
    this.slug,
  });

  List<String>? institution;
  bool? softDelete;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? v;
  String? name;
  String? slug;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    institution: List<String>.from(json["institution"].map((x) => x)),
    softDelete: json["soft_delete"],
    id: json["_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    name: json["name"],
    slug: json["slug"],
  );

  Map<String, dynamic> toJson() => {
    "institution": List<dynamic>.from(institution!.map((x) => x)),
    "soft_delete": softDelete,
    "_id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "name": name,
    "slug": slug,
  };
}
