// To parse this JSON data, do
//
//     final addLessonResponse = addLessonResponseFromJson(jsonString);

import 'dart:convert';

AddLessonResponse addLessonResponseFromJson(String str) => AddLessonResponse.fromJson(json.decode(str));

String addLessonResponseToJson(AddLessonResponse data) => json.encode(data.toJson());

class AddLessonResponse {
  AddLessonResponse({
    this.success,
    this.module,
    this.message,
    this.lesson,
  });

  bool ? success;
  dynamic module;
  String ? message;
  String ? lesson;

  factory AddLessonResponse.fromJson(Map<String, dynamic> json) => AddLessonResponse(
    success: json["success"],
    module: json["module"],
    message: json["message"],
    lesson: json["lesson"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "module": module,
    "message": message,
    "lesson": lesson,
  };
}
