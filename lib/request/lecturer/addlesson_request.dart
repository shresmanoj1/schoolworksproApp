// To parse this JSON data, do
//
//     final addLessonRequest = addLessonRequestFromJson(jsonString);

import 'dart:convert';

AddLessonRequest addLessonRequestFromJson(String str) => AddLessonRequest.fromJson(json.decode(str));

String addLessonRequestToJson(AddLessonRequest data) => json.encode(data.toJson());

class AddLessonRequest {
  AddLessonRequest({
    this.lessonTitle,
    this.type,
    this.week,
    this.lessonContents,
    this.moduleSlug,
    this.audioEnabled,
  });

  String ? lessonTitle;
  String ? type;
  int ? week;
  String ? lessonContents;
  String ? moduleSlug;
  bool ? audioEnabled;

  factory AddLessonRequest.fromJson(Map<String, dynamic> json) => AddLessonRequest(
    lessonTitle: json["lessonTitle"],
    type: json["type"],
    week: json["week"],
    lessonContents: json["lessonContents"],
    moduleSlug: json["moduleSlug"],
    audioEnabled: json["audioEnabled"],
  );

  Map<String, dynamic> toJson() => {
    "lessonTitle": lessonTitle,
    "type": type,
    "week": week,
    "lessonContents": lessonContents,
    "moduleSlug": moduleSlug,
    "audioEnabled": audioEnabled,
  };
}
