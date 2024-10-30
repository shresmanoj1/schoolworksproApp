// To parse this JSON data, do
//
//     final lessonalreadystartedresponse = lessonalreadystartedresponseFromJson(jsonString);

import 'dart:convert';

Lessonalreadystartedresponse lessonalreadystartedresponseFromJson(String str) =>
    Lessonalreadystartedresponse.fromJson(json.decode(str));

String lessonalreadystartedresponseToJson(Lessonalreadystartedresponse data) =>
    json.encode(data.toJson());

class Lessonalreadystartedresponse {
  Lessonalreadystartedresponse({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory Lessonalreadystartedresponse.fromJson(Map<String, dynamic> json) =>
      Lessonalreadystartedresponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
