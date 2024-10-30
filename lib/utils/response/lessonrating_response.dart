// To parse this JSON data, do
//
//     final lessonratingResponse = lessonratingResponseFromJson(jsonString);

import 'dart:convert';

LessonratingResponse lessonratingResponseFromJson(String str) =>
    LessonratingResponse.fromJson(json.decode(str));

String lessonratingResponseToJson(LessonratingResponse data) =>
    json.encode(data.toJson());

class LessonratingResponse {
  LessonratingResponse({
    this.success,
    this.rating,
  });

  bool? success;
  Rating? rating;

  factory LessonratingResponse.fromJson(Map<String, dynamic> json) =>
      LessonratingResponse(
        success: json["success"],
        rating: Rating.fromJson(json["rating"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "rating": rating!.toJson(),
      };
}

class Rating {
  Rating({
    this.rating,
    this.id,
    this.lessonSlug,
    this.institution,
    this.username,
    this.createdAt,
  });

  double? rating;
  String? id;
  String? lessonSlug;
  String? institution;
  String? username;
  DateTime? createdAt;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rating: json["rating"].toDouble(),
        id: json["_id"],
        lessonSlug: json["lessonSlug"],
        institution: json["institution"],
        username: json["username"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "_id": id,
        "lessonSlug": lessonSlug,
        "institution": institution,
        "username": username,
        "createdAt": createdAt!.toIso8601String(),
      };
}
