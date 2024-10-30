// To parse this JSON data, do
//
//     final bookresponse = bookresponseFromJson(jsonString);

import 'dart:convert';

import 'dart:io';

Bookresponse bookresponseFromJson(String str) =>
    Bookresponse.fromJson(json.decode(str));

String bookresponseToJson(Bookresponse data) => json.encode(data.toJson());

class Bookresponse {
  Bookresponse({
    this.books,
    this.success,
  });

  List<Book>? books;
  bool? success;

  factory Bookresponse.fromJson(Map<String, dynamic> json) => Bookresponse(
        books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "books": List<dynamic>.from(books!.map((x) => x.toJson())),
        "success": success,
      };
}

class Book {
  Book({
    this.id,
    this.bookName,
    this.bookSlug,
    this.size,
    this.bookFile,
    this.bookCategory,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? bookName;
  String? bookSlug;
  String? size;
  String? bookFile;
  BookCategory? bookCategory;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["_id"],
        bookName: json["book_name"],
        bookSlug: json["book_slug"],
        size: json["size"],
        bookFile: json["book_file"],
        bookCategory: BookCategory.fromJson(json["book_category"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "book_name": bookName,
        "book_slug": bookSlug,
        "size": size,
        "book_file": bookFile,
        "book_category": bookCategory!.toJson(),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
      };
}

class BookCategory {
  BookCategory({
    this.id,
    this.categoryName,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? categoryName;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory BookCategory.fromJson(Map<String, dynamic> json) => BookCategory(
        id: json["_id"],
        categoryName: json["category_name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "category_name": categoryName,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
      };
}
