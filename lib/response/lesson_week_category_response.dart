// To parse this JSON data, do
//
//     final lessonWeekCategoryResponse = lessonWeekCategoryResponseFromJson(jsonString);

import 'dart:convert';

LessonWeekCategoryResponse lessonWeekCategoryResponseFromJson(String str) => LessonWeekCategoryResponse.fromJson(json.decode(str));

String lessonWeekCategoryResponseToJson(LessonWeekCategoryResponse data) => json.encode(data.toJson());

class LessonWeekCategoryResponse {
  bool? success;
  String? message;
  List<Category>? categories;

  LessonWeekCategoryResponse({
    this.success,
    this.message,
    this.categories,
  });

  factory LessonWeekCategoryResponse.fromJson(Map<String, dynamic> json) => LessonWeekCategoryResponse(
    success: json["success"],
    message: json["message"],
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "categories": List<dynamic>.from(categories!.map((x) => x.toJson())),
  };
}

class Category {
  List<String>? weeks;
  String? id;
  String? moduleSlug;
  String? title;
  String? institution;

  Category({
    this.weeks,
    this.id,
    this.moduleSlug,
    this.title,
    this.institution,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    weeks: List<String>.from(json["weeks"].map((x) => x)),
    id: json["_id"],
    moduleSlug: json["moduleSlug"],
    title: json["title"],
    institution: json["institution"],
  );

  Map<String, dynamic> toJson() => {
    "weeks": List<dynamic>.from(weeks!.map((x) => x)),
    "_id": id,
    "moduleSlug": moduleSlug,
    "title": title,
    "institution": institution,
  };
}
